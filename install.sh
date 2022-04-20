
if [ "$1" ];then


if [ "$(uname -a | grep -E '(Kali|kali)')" ];
then
apt install assetfinder
apt install subfinder
apt install sublist3r
apt install getallurls
apt install nmap
apt install dirsearch
apt install sslscan
else
apt install nmap
go get github.com/projectdiscovery/subfinder
go get github.com/tomnomnom/assetfinder
git clone git clone https://github.com/aboul3la/Sublist3r.git $1/sublist3r
go get github.com/lc/gau/v2/cmd/gau
git clone https://github.com/maurosoria/dirsearch.git
apt-get install build-essential git zlib1g-dev
apt-get build-dep openssl
git clone https://github.com/rbsec/sslscan

fi
mkdir $1
git clone https://github.com/michenriksen/aquatone $1/aquatone
git clone https://github.com/projectdiscovery/nuclei $1/nuclei
git clone https://github.com/tomnomnom/hacks/ $1/hacks
git clone https://github.com/tomnomnom/anew $1/anew
git clone https://github.com/tomnomnom/gf $1/gf
git clone https://github.com/003random/getJS $1/getjs


else


echo "error: please provide the download path for tools"

fi
