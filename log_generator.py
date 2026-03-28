import random
import time
import json
import os

BASE_DIR = os.getcwd()
LOGS_DIR = os.path.join(BASE_DIR, "logs")

COUNTRIES = [
    {"name": "Russia", "ip": "185.220.101.42"},
    {"name": "China", "ip": "45.142.212.100"},
    {"name": "Iran", "ip": "103.253.145.50"},
    {"name": "North Korea", "ip": "91.219.236.200"},
    {"name": "Brazil", "ip": "185.156.73.88"}
]

USERS = ["root", "admin", "ubuntu", "ec2-user", "oracle"]

print("ATTACK SIMULATOR STARTED")

while True:
    country = random.choice(COUNTRIES)
    user = random.choice(USERS)

    alert = {
        "attack_type": "SSH Brute Force",
        "severity": "CRITICAL",
        "threat_score": random.randint(85, 99),
        "country": country["name"],
        "target_user": user,
        "mitre_id": "T1110",
        "attacker_ip": country["ip"]
    }

    try:
        with open(os.path.join(LOGS_DIR, "alerts.json"), "r") as f:
            alerts = json.load(f)
    except:
        alerts = []

    alerts.append(alert)
    alerts = alerts[-10:]

    with open(os.path.join(LOGS_DIR, "alerts.json"), "w") as f:
        json.dump(alerts, f, indent=2)

    print(country["name"], "| user:", user, "| total:", len(alerts))

    time.sleep(2)
