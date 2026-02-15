Automatically downloads, merges, deduplicates, and updates multiple high-confidence IP threat blocklists every 12 hours


🔐 Auto-Update IP Threat Blocklist

This repository contains an automated PowerShell script that:

Downloads multiple trusted IP threat intelligence feeds

Removes comments and empty lines

Deduplicates all IPs and CIDR ranges

Generates a clean combined blocklist

The goal is to maintain a low false-positive, high-confidence IP blocklist suitable for firewalls, routers, and DNS filtering systems.

📦 Sources Included

This combined list pulls from:

Website: https://iplists.firehol.org/
FireHOL Cybercrime
FireHOL ET Compromised
FireHOL Level 2

Spamhaus DROP (official)
Website: https://www.spamhaus.org/

HaGeZi TIF IP list
Website: https://github.com/hagezi/dns-blocklists

blocklist.de SIP/FTP attackers
Website: https://www.blocklist.de/en/

All sources are reputable and focused on:
Malware infrastructure
Botnet controllers
Compromised hosts
Criminal hosting networks
Scanner and attack sources
