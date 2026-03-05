# 🛡️ Blocklist

[![Update Status](https://github.com/jmpatag/Firewall-Blocklist/actions/workflows/update-blocklist.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions)

An ultra-lean IP blocklist optimized for low-RAM/CPU firewalls.
---

### 🚀 Features
* **Auto-Cleaning:** Uses Regex to strip comments and invalid data.
* **Optimized:** Merges sources, removes duplicates, and sorts numerically.

### 📡 Sources
* **FireHOL** (Cybercrime/Compromised) - https://iplists.firehol.org/
* **HaGeZi** (DNS/Threat Intelligence) - https://github.com/hagezi/dns-blocklists
* **Spamhaus DROP** (Malicious Networks) - https://www.spamhaus.org/drop/
* **Blocklist.de** (SSH/FTP/SIP Attacks) - https://www.blocklist.de/

### 📂 Output Data
👉 **[Download Combined Blocklist](./combined_blocklist.txt)**

---

### ⚠️ Disclaimer
I manage the processing and aggregation for this list. While the threat intelligence comes from external providers, I handle the filtering and deduplication to ensure the final file is as lean as possible for my hardware.

* **Accuracy:** I do not verify the malicious nature of the IPs; I rely on the upstream providers listed above.
* **Responsibility:** False positives may occur. Blocking decisions and their impact on your network are your sole responsibility.
