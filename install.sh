
if [ "$1" ];then

cpwd=$PWD
  if [ "$(uname -a | grep -E '(Kali|kali)')" ];
  then
    apt install assetfinder
    apt install subfinder
    apt install getallurls
    apt install nmap
    apt install dirsearch
    apt install sslscan
  else
    apt install nmap
    go install github.com/projectdiscovery/subfinder@latest
    go install github.com/tomnomnom/assetfinder@latest
    go install github.com/lc/gau/v2/cmd/gau@latest
    apt-get install build-essential git zlib1g-dev
    apt-get build-dep openssl
    git clone https://github.com/maurosoria/dirsearch.git
    git clone https://github.com/rbsec/sslscan

  fi
  
  go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
  go install https://github.com/tomnomnom/anew@latest
  go install https://github.com/tomnomnom/gf@latest
  go install github.com/003random/getJS@latest
  cd $1
  wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip;
  unzip aquatone_linux_amd64_1.7.0.zip
  ln -s $PWD/aquatone /usr/bin/aquatone
  cd $cpwd;



else


echo "error: please provide the download path for tools"

fi
