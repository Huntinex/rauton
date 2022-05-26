#!/bin/bash
#############################################################
######################### CONFIG ############################

dirsearch_wordlist_path=/tls/wordlist/dirsearch.txt

#############################################################

# colors
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
yellow=`tput setaf 3`
magenta=`tput setaf 5`
reset=`tput sgr0`
bold=`tput bold`
bw=`tput setab 7`



recon (){
	if [ "$2" = "wild" ]; then
		echo "${yellow}[#] Subdomain Recon";
		assetfinder $1 > subs;
		echo "${yellow}[#] HTTP Validation";
		cat subs | httprobe -prefer-https | qsreplace | sed 's/https\?:\/\///' | anew -q valid_domains;
	fi
	################### Pro Recon ########################
	######## fingerprint

	mkdir fingerprint;
	cd fingerprint;
	if [ "$2" = "wild" ]; then
	cat valid_domains > allhosts
	echo "${yellow}[#] Web FingerPrinting";
	gowitness file -f ../allhosts
	gowitness report serve &>/dev/null &
	echo "${green}[+] Web server for view results started at http://localhost:7171"
	fi
	# jsfiles
	# js ./fingerprint/alivejs.txt
	echo "${yellow}[#] Finding ${red}Urls";
	mkdir wayback-data
	if [ "$2" = "wild" ];
	then
		getallurls -subs $1 | tee wayback-data/waybackurls.txt
		echo $1 | waybackurls | tee -a wayback-data/waybackurls.txt
	else
		getallurls $1 | tee wayback-data/waybackurls.txt
		echo $1 | waybackurls -no-subs | tee -a wayback-data/waybackurls.txt
	fi
	echo $1 | waybackurls
	echo "${yellow}[#] Finding ${red}Js Files";
	
		cat urls.txt |grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js.txt ; cat js.txt | anti-burl | awk '{print $4}' | sort -u >> alivejs.txt
		getjs --input ../valid_domains >> alivejs.txt
		cat alivejs.txt 
	echo "${yellow}[#] Finding ${red}CIDR";
	echo "${green}";
	if [ "$2" = "wild" ]; then
		for DOMAIN in $(cat ../valid_domains);do echo ${blue}$(for ip in $(dig a $DOMAIN +short); do whois $ip | grep -e "CIDR\|Organization" |tr -s " " | paste - -; done | uniq); done
	else
		echo ${blue}$(for ip in $(dig a $1 +short); do whois $ip | grep -e "CIDR\|Organization" |tr -s " " | paste - -; done | uniq);
	fi
	# network 
	# nmap ./fingerpring/network.txt
	echo "${yellow}[#] Finding ${red}Open Ports";
	echo "${blue}";
	
	if [ "$2" = "wild" ]; then
	cat subs | nmap -sV -T3 -Pn -p3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,7447,7080,8880,8983,5673,7443,19000,19080 -iL /dev/stdin |  grep -E 'open|filtered|closed' > network.txt
	else
	nmap -sV -T3 -Pn -p3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,7447,7080,8880,8983,5673,7443,19000,19080 $1 |  grep -E 'open|filtered|closed' > network.txt
	fi
	
	echo "${green}"
	cat network.txt
	# httpscan
	echo "${yellow}[#] Starting ${red}HTTP Scan";
	if [ "$2" = "wild" ]; then
		nmap --script "http-*" -iL allhosts -p 443 > httpscan
	else
		nmap --script "http-*" -p 443 $1 > httpscan
	fi
	echo "${green}";
	cat httpscan
	cat wayback-data/waybackurls.txt  | sort -u | unfurl --unique keys > wayback-data/paramlist.txt
	[ -s wayback-data/paramlist.txt ]

	cat wayback-data/waybackurls.txt  | sort -u | grep -P "\w+\.php(\?|$) | sort -u " > wayback-data/phpurls.txt
	[ -s wayback-data/phpurls.txt ]

	cat wayback-data/waybackurls.txt  | sort -u | grep -P "\w+\.aspx(\?|$) | sort -u " > wayback-data/aspxurls.txt
	[ -s wayback-data/aspxurls.txt ]

	cat wayback-data/waybackurls.txt  | sort -u | grep -P "\w+\.jsp(\?|$) | sort -u " > wayback-data/jspurls.txt
	[ -s wayback-data/jspurls.txt ]
	# getvulnerablelinks
	echo "${yellow}[#] Finding ${red}Vulnerable Links";
	mkdir vulnlinks
	cat wayback-data/waybackurls.txt | grep = | gf xss > vulnlinks/xss
	cat wayback-data/waybackurls.txt | grep = | gf ssti > vulnlinks/ssti
	cat wayback-data/waybackurls.txt | grep = | gf sqli > vulnlinks/sqli
	cat wayback-data/waybackurls.txt | grep = | gf redirect > vulnlinks/redirect
	cat wayback-data/waybackurls.txt | grep = | gf rce > vulnlinks/rce
	cat wayback-data/waybackurls.txt | grep = | gf idor > vulnlinks/idor
	cat wayback-data/waybackurls.txt | grep = | gf ssrf > vulnlinks/ssrf
	cat wayback-data/waybackurls.txt | grep = | gf lfi > vulnlinks/lfi
	# nucleitest 
	echo "${yellow}[#] Scan With ${red}Nuclei";
	if [ "$2" = "wild" ]; then
		cat allhosts | nuclei -o nuclei_recon_output -silent -s info
		cat allhosts | nuclei -o nuclei_output -silent -s low,medium,high,critical
	else 
		echo $1 | nuclei -o nuclei_recon_output -silent -s info
		echo $1 | nuclei -o nuclei_output -silent -s low,medium,high,critical
	fi
	# dirfuzz
	mkdir fuzzing;
	echo "${yellow}[#] Finding ${red}Directories and Sensitive Files";
	dirsearch -u $1 -t 500 -o fuzzing/dirsearch -w $dirsearch_wordlist_path 

	#sensitivefuzz
		#NOTHING
		# echo "";

	# sslcheck 
	echo "${yellow}[#] Checking ${red}SSL";
	echo "  ${blue}[#] SSL Ciphers : "
	nmap --script ssl-enum-ciphers -p 443 $1
	echo "  ${blue}[#] Heartbleed : "
	sslscan $1 | grep heartbleed
	# getips
	if [ "$2" = "wild" ]; then
	echo "${yellow}[#] Getting Subdomains ${red}IPs";
	for sub in $(cat ../valid_domains);do echo "${wb}${red}$sub${reset} ${blue}---> ${yellow}$(dig +short a $sub | tail -n1)" | anew ;done | anew | sort -u
	else
	echo "${yellow}[#] Getting Server ${red}IP";
    echo "${wb}${red}$sub${reset} ${blue}---> ${yellow}$(dig +short a $sub | tail -n1)" | anew | sort -u

	fi
	echo "${green}[+] Scan For $1 finished successfully";

}

case "$1" in
single|-single|--single|-s)
	echo "${green}[+] Starting Scan On ${yellow}$2 ${green}in ${red}Single ${green}Mode";
	mkdir $2
	cd $2
	recon $2 "single"
	
;;
wild|-wild|--wildcard|--wild|-w|wildcard|-wildcard)
	echo "${green}[+] Starting Scan On ${yellow}$2 ${green}in ${red}Wildcard ${green}Mode";
	mkdir $2 2>/dev/null
	cd $2
	recon $2 "wild"
;;
*)
	echo "${red}[-] Not Any Mode Selected !";
	echo "${green}[+] Starting Scan On ${yellow}$1 ${green}in ${red}Wildcard (Default) ${green}Mode";
	mkdir $1 2>/dev/null
	cd $1
	recon $1 "wild"

;;

esac
