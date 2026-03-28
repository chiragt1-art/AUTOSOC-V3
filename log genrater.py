import random
import time
import json
import os

BASE_DIR = os.getcwd()
LOGS_DIR = os.path.join(BASE_DIR, "logs")

COUNTRIES = [
    {"name": "Russia", "ip": "185.220.101.42", "lat": 55.7558, "lon": 37.6173},
    {"name": "China", "ip": "45.142.212.100", "lat": 35.8617, "lon": 104.1954},
    {"name": "Iran", "ip": "103.253.145.50", "lat": 32.4279, "lon": 53.6880},
    {"name": "North Korea", "ip": "91.219.236.200", "lat": 40.3399, "lon": 127.5101},
    {"name": "Brazil", "ip": "185.156.73.88", "lat": -14.2350, "lon": -51.9253}
]

USERS = ["root", "admin", "ubuntu", "ec2-user", "oracle"]
alert_id = 1002

print("ATTACK SIMULATOR STARTED")
print("Press Ctrl+C to stop\n")

while True:
    country = random.choice(COUNTRIES)
    user = random.choice(USERS)
    
    alert = {
        "id": alert_id,
        "attack_type": "SSH Brute Force",
        "severity": "CRITICAL",
        "threat_score": random.randint(85, 99),
        "country": country["name"],
        "target_user": user,
        "mitre_id": "T1110",
        "attacker_ip": country["ip"],
        "lat": country["lat"],
        "lon": country["lon"]
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
    
    print(f"{country['name']}: Attack on '{user}' | Score: {alert['threat_score']}/100 | Total: {len(alerts)}")
    
    alert_id += 1
    time.sleep(2)