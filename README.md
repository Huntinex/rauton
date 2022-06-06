# Rauton
Bug Bounty Recon Automation Tool

![ScreenShot](https://i.imgur.com/VCVWtQf.png)


## Features :
- Take Screenshots from subdomains via @sensepost/gowitness
- Get title and headers from subdomains via @sensepost/gowitness
- General info about company and CIDRs
- Network scan via @nmap/nmap
- HTTP scan via @nmap/nmap
- Collecting and separating archives urls via @tomnomnom/unfurl, @tomnomnom/gf, @lc/gau, @tomnomnom/waybackurls
- Templated-based vulnerability scan with @projectdiscovery/nuclei
- Directory fuzzing with @maurosoria/dirsearch
- SSL scan with @rbsec/sslscan
- Get all host IPs from subdomains

## Installation :
1. Clone the repository with `git clone https://github.com/Huntinex/rauton`
2. Run installation file `./install.sh`
3. Edit the script `CONFIG` section and enter your `dirsearch_wordlist_path` .

## Usage :
For single domains use :
```bash
./rauton.sh -single apple.com
# or (default mode is single)
./rauton.sh apple.com
```
And for wildcard domains use :
```bash
./rauton.sh -wild apple.com
```
---
