# Rauton
A small bug bounty reconnaissance automation tool.

![ScreenShot](https://i.imgur.com/VCVWtQf.png)


## Features :
- Take Screenshots from subdomains via @sensepost/gowitness
- Get title and headers from subdomains via @sensepost/gowitness
- General info about company and CIDRs
- Network scan via @nmap/nmap
- HTTP scan via @nmap/nmap
- Collecting and separating archive urls via @tomnomnom/unfurl, @tomnomnom/gf, @lc/gau, @tomnomnom/waybackurls
- Templated-based vulnerability scan with @projectdiscovery/nuclei
- Directory fuzzing with @maurosoria/dirsearch
- SSL scan with @rbsec/sslscan
- Get all host IPs from subdomains

## Installation :
1. Clone the repository with the following command :
```bash
git clone https://github.com/Huntinex/rauton
```

2. Run the installation file : 
```bash
./install.sh
```

3. Edit the script configuration section and enter your `dirsearch_wordlist_path`.

## Usage :
For a single domain use :
```bash
./rauton.sh -single apple.com
# or (default mode is single)
./rauton.sh apple.com
```

And for wildcard domains use :
```bash
./rauton.sh -wild apple.com
```
