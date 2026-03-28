 🔥 AUTOSOC v3.0 — Real-Time AWS Security Operations Center

![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python)
![AWS](https://img.shields.io/badge/AWS-EC2-orange?style=for-the-badge&logo=amazonaws)
![Wazuh](https://img.shields.io/badge/SIEM-Wazuh_v4.7.5-red?style=for-the-badge)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-darkred?style=for-the-badge)
![Flask](https://img.shields.io/badge/Flask-Python-black?style=for-the-badge&logo=flask)
![Kali](https://img.shields.io/badge/Kali-Linux-blue?style=for-the-badge&logo=kalilinux)

> 💀 Built by a fresher. Runs like an enterprise SOC.

---

## 🎥 Live Demo

[![Watch Demo](https://img.shields.io/badge/YouTube-Watch_Demo-red?style=for-the-badge&logo=youtube)](https://youtu.be/xCdGg--E6SM)

👆 Click to watch the full demo — real attacks detected in real time!

---

## 🎯 What is AUTOSOC v3.0?

AUTOSOC v3.0 is a *fully functional, real-time Security Operations Center* built completely on AWS using free tier resources.

It detects *live cyberattacks* from Kali Linux, maps them to *MITRE ATT&CK techniques, and displays everything on a **custom-built dashboard* — all within 10 seconds of the attack happening.

> ⚡ This is NOT a simulation. Real attacks. Real detection. Real dashboard.

---

## 🏗️ Complete Architecture

╔═══════════════════════════════════════════════════╗
║                  AWS CLOUD LAB                    ║
║                                                   ║
║  ┌─────────────┐         ┌─────────────┐         ║
║  │  ATTACKER   │ attacks │   VICTIM    │         ║
║  │ Kali Linux  │────────▶│ Ubuntu EC2  │         ║
║  │ nmap, hydra │         │ Wazuh Agent │         ║
║  └─────────────┘         └──────┬──────┘         ║
║                                 │ detects         ║
║                                 ▼                 ║
║                        ┌─────────────┐           ║
║                        │   SERVER    │           ║
║                        │Wazuh Manager│           ║
║                        │  v4.7.5     │           ║
║                        └──────┬──────┘           ║
╚══════════════════════════════ │ ══════════════════╝
                                │ SSH pull every 10s
                                ▼
                   ┌────────────────────────┐
                   │    YOUR LOCAL PC       │
                   │  wazuh_collector.py    │
                   │         ↓              │
                   │   logs/alerts.json     │
                   │         ↓              │
                   │  AUTOSOC Dashboard     │
                   │  http://localhost:5000 │
                   │  560+ LIVE ALERTS! 🔥  │
                   └────────────────────────┘


---

## 🚨 Real Results From My Demo

Total Alerts Detected  : 560+
Wazuh Live Alerts      : 50 per session
Wazuh Total Events     : 5,868
Authentication Success : 1,916
MITRE Techniques Found : T1548, T1078, T1110, T1562
Attack Sources         : Russia, China, Iran, Brazil
Dashboard Refresh      : Every 10 seconds


---

## ⚡ Key Features

| Feature | Description |
|---------|-------------|
| 🔴 Live Detection | Alerts appear within 10 seconds of attack |
| 🗺️ World Map | Shows real-time attack source locations |
| 📊 Live Charts | Attack frequency and severity distribution |
| 🎯 MITRE Mapping | Every alert mapped to ATT&CK technique |
| 🔥 Threat Heatmap | Visual severity across time |
| 📡 Multi-Source | Wazuh + CloudTrail + SSH logs combined |
| 🚨 560+ Alerts | Detected in a single demo session |
| ⚡ Auto Refresh | Dashboard updates every 10 seconds |

---

## 🛠️ Complete Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Cloud | AWS EC2 x3 | Server, Victim, Attacker |
| SIEM | Wazuh v4.7.5 | Threat detection engine |
| Attacker | Kali Linux | Attack simulation |
| Backend | Python Flask | REST API + Dashboard |
| Frontend | Chart.js + Leaflet | Charts and world map |
| UI | Bootstrap 5 | Responsive layout |
| Collection | Python Paramiko | SSH-based log pulling |
| Framework | MITRE ATT&CK | Threat classification |
| AWS Services | CloudTrail + GuardDuty | Cloud threat detection |

---

## 🔥 Attacks Simulated and Detected

| Attack | Tool | MITRE ID | Tactic | Detected |
|--------|------|----------|--------|----------|
| Network Port Scan | nmap -A -sV -sC | T1046 | Discovery | ✅ YES |
| SSH Brute Force | hydra | T1110 | Credential Access | ✅ YES |
| Privilege Escalation | sudo abuse | T1548.003 | Privilege Escalation | ✅ YES |
| Defense Evasion | CloudTrail delete | T1562.008 | Defense Evasion | ✅ YES |
| Backdoor User | IAM CreateUser | T1136.003 | Persistence | ✅ YES |
| Unauthorized Access | AccessDenied | T1078 | Initial Access | ✅ YES |
| Admin Policy Attach | AttachUserPolicy | T1098 | Persistence | ✅ YES |
| S3 Data Exposure | PutBucketPolicy | T1530 | Exfiltration | ✅ YES |

---

## 📁 Project Structure

AUTOSOC/
│
├── app.py                  # Flask backend + full dashboard HTML
├── wazuh_collector.py      # SSH collector — pulls live Wazuh alerts
├── log_generator.py        # Attack log simulator
│
├── logs/
│   ├── alerts.json         # Live Wazuh alerts (auto-updated)
│   ├── aws_auth_logs.txt   # SSH authentication logs
│   └── cloudtrail.json     # AWS CloudTrail events
│
└── README.md               # This file


---

## ⚙️ How to Run This Project

### Prerequisites
bash
pip install flask paramiko boto3


### Step 1 — Clone the repo
bash
git clone https://github.com/chiragt1-art/AUTOSOC-V3.git
cd AUTOSOC-V3


### Step 2 — Configure Wazuh collector
Open wazuh_collector.py and set:
python
SERVER_IP = "your-wazuh-server-public-ip"
SSH_USER  = "ubuntu"
PEM_KEY   = "path/to/your-key.pem"


### Step 3 — Start dashboard
bash
python app.py

Open: http://localhost:5000

### Step 4 — Start Wazuh collector
bash
python wazuh_collector.py


### Step 5 — Simulate attack from Kali Linux
bash
nmap -A -sV 172.31.73.237


### Step 6 — Watch alerts appear LIVE on dashboard! 🔥

---

## 🖥️ AWS Lab Setup

Instance 1 — Wazuh Server
   OS     : Ubuntu 22.04
   Install: Wazuh Manager v4.7.5
   Ports  : 1514, 1515, 55000

Instance 2 — Victim
   OS     : Ubuntu 22.04
   Install: Wazuh Agent
   Connect: Points to Wazuh Server

Instance 3 — Attacker
   OS     : Kali Linux
   Tools  : nmap, hydra, metasploit
   Target : Victim instance private IP


---

## 📊 Dashboard Sections

┌─────────────────────────────────────────────┐
│  AUTOSOC v3.0 — AWS Network Security        │
├──────────┬──────────┬──────────┬────────────┤
│Total Flow│Unique Src│Unique Dst│Flow Sessions│
├──────────┴──────────┴──────────┴────────────┤
│  Largest Communications by IP (Bar Chart)   │
│  Egress Regions by Session Count (Bar)      │
├─────────────────────────────────────────────┤
│  Most Active Ingress Countries (Donut)      │
│  Attack Sources on World Map (Leaflet)      │
├─────────────────────────────────────────────┤
│  Recent Alerts and Flows                    │
│  Total: 560+ | Critical: X | Wazuh Live: X │
├─────────────────────────────────────────────┤
│  🚨 Live Wazuh Alerts (scrollable list)    │
│  [Wazuh-LIVE] CRITICAL — Privilege Escal.. │
│  [Wazuh-LIVE] HIGH — PAM Login Session...  │
└─────────────────────────────────────────────┘


---

## 🧠 What I Learned

- Setting up a real AWS SOC lab with 3 EC2 instances
- Installing and configuring Wazuh SIEM v4.7.5 from scratch
- SSH-based real-time log collection using Python Paramiko
- Building a live streaming web dashboard with Flask
- MITRE ATT&CK framework — understanding real attack techniques
- Kali Linux penetration testing — nmap, hydra
- Flask REST API development
- AWS services — EC2, Security Groups, CloudTrail, GuardDuty, IAM
- Real enterprise SOC analyst workflow

---

## 💡 How This Mirrors Real Enterprise SOCs

Real SOC                    AUTOSOC v3.0
─────────────────────────────────────────
SIEM (Splunk/QRadar)   →   Wazuh v4.7.5
Log Collectors         →   wazuh_collector.py
Analyst Dashboard      →   Flask + Chart.js
MITRE Mapping          →   Auto-mapped alerts
Threat Intelligence    →   IP country mapping
Incident Response      →   Real-time alerts
Red Team               →   Kali Linux attacks


---

## 🎥 Demo Video

[![YouTube Demo](https://img.shields.io/badge/▶_Watch_Full_Demo-YouTube-red?style=for-the-badge&logo=youtube)](https://youtu.be/xCdGg--E6SM)

In the video you will see:
- Complete AWS lab setup explanation
- Real Kali Linux nmap attack on victim EC2
- Wazuh detecting the attack in real time
- AUTOSOC dashboard updating with live alerts
- MITRE ATT&CK techniques being mapped
- 560+ alerts in a single session

---

## 👨‍💻 About The Builder

*Chirag Thakur*
Cybersecurity Fresher — India 🇮🇳

Built an enterprise-grade SOC from scratch using only:
- AWS Free Tier
- Open source tools
- Zero budget
- Lots of determination 💪

> Most freshers build todo apps.
> I built a Security Operations Center. 🔥

---

## ⭐ Support This Project

If this project impressed you:
- Give it a ⭐ star on GitHub
- Share it with your network
- Watch the demo on YouTube

[![GitHub](https://img.shields.io/badge/GitHub-chiragt1--art-black?style=for-the-badge&logo=github)](https://github.com/chiragt1-art)
[![YouTube](https://img.shields.io/badge/YouTube-Demo_Video-red?style=for-the-badge&logo=youtube)](https://youtu.be/xCdGg--E6SM)
