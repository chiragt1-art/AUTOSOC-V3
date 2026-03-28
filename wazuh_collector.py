import paramiko
import json
import os
import time
from datetime import datetime

# ===== CONFIGURATION =====
SERVER_IP = "34.203.196.192"
SSH_USER = "ubuntu"
PEM_KEY = r"C:\Users\HP\Downloads\projectpair.pem"
REMOTE_ALERTS = "/var/ossec/logs/alerts/alerts.json"
POLL_SECONDS = 3

BASE_DIR = os.getcwd()
LOGS_DIR = os.path.join(BASE_DIR, "logs")
ALERTS_FILE = os.path.join(LOGS_DIR, "alerts.json")
os.makedirs(LOGS_DIR, exist_ok=True)

last_seen_time = None

def get_severity(level):
    level = int(level) if level else 0
    if level >= 12:
        return "CRITICAL", 99
    elif level >= 10:
        return "HIGH", 85
    elif level >= 7:
        return "HIGH", 75
    else:
        return "MEDIUM", 60

def connect_ssh():
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(SERVER_IP, username=SSH_USER, key_filename=PEM_KEY, timeout=10)
        return ssh
    except Exception as e:
        print(f"❌ SSH Error: {e}")
        return None

def get_new_alerts(ssh):
    global last_seen_time
    new_alerts = []
    
    try:
        # Read last 200 lines of alerts
        stdin, stdout, stderr = ssh.exec_command(f"sudo tail -200 {REMOTE_ALERTS}")
        content = stdout.read().decode('utf-8', errors='ignore')
        
        if not content:
            return new_alerts
        
        for line in content.strip().split('\n'):
            line = line.strip()
            if not line:
                continue
            
            try:
                event = json.loads(line)
                rule = event.get("rule", {})
                level = rule.get("level", 0)
                event_time = event.get("timestamp")
                
                # Skip low-level alerts
                if level < 3:
                    continue
                
                # Skip alerts older than last seen
                if last_seen_time and event_time and event_time <= last_seen_time:
                    continue
                
                # Update last seen time
                if event_time:
                    last_seen_time = event_time
                
                severity, score = get_severity(level)
                agent = event.get("agent", {})
                data = event.get("data", {})
                mitre = rule.get("mitre", {})
                
                attacker_ip = data.get("srcip") or data.get("src_ip") or "Internal"
                mitre_ids = mitre.get("id", ["T0000"])
                mitre_id = mitre_ids[0] if isinstance(mitre_ids, list) else mitre_ids
                
                alert = {
                    "attack_type": rule.get("description", "Unknown"),
                    "severity": severity,
                    "threat_score": score,
                    "country": "AWS-Lab",
                    "target_user": data.get("dstuser") or agent.get("name") or "unknown",
                    "mitre_id": mitre_id,
                    "attacker_ip": attacker_ip,
                    "agent_name": agent.get("name", "unknown"),
                    "wazuh_level": level,
                    "timestamp": event_time,
                    "source": "Wazuh-LIVE"
                }
                
                new_alerts.append(alert)
            
            except Exception:
                continue
        
        return new_alerts
    
    except Exception as e:
        print(f"❌ Error: {e}")
        return new_alerts

def load_local_alerts():
    if os.path.exists(ALERTS_FILE):
        try:
            with open(ALERTS_FILE, 'r') as f:
                return json.load(f)
        except:
            return []
    return []

def save_alerts(alerts):
    with open(ALERTS_FILE, 'w') as f:
        json.dump(alerts, f, indent=2)

def main():
    global last_seen_time
    
    print("=" * 60)
    print("🔥 AUTOSOC FINAL REAL-TIME COLLECTOR")
    print("=" * 60)
    print(f"Server: {SERVER_IP}")
    print(f"Local File: {ALERTS_FILE}")
    print(f"Polling: {POLL_SECONDS} seconds")
    print("=" * 60)
    
    ssh = connect_ssh()
    if not ssh:
        print("\n❌ CANNOT CONNECT TO SERVER!")
        print("Check:")
        print("1. EC2 instance running?")
        print("2. PEM key path correct?")
        print("3. Security group allows SSH?")
        return
    
    print("\n✅ CONNECTED! Waiting for attacks...\n")
    
    while True:
        try:
            # Get NEW alerts
            new_alerts = get_new_alerts(ssh)
            
            if new_alerts:
                # Load existing alerts
                existing = load_local_alerts()
                
                # APPEND new ones
                existing.extend(new_alerts)
                
                # Save
                save_alerts(existing)
                
                # Show output
                ts = datetime.now().strftime('%H:%M:%S')
                print(f"[{ts}] 🆕 +{len(new_alerts)} NEW ATTACKS!")
                for alert in new_alerts:
                    print(f"   ⚠️  {alert['attack_type']} | IP: {alert['attacker_ip']} | {alert['severity']}")
                print(f"📊 Total Alerts: {len(existing)}\n")
            
            time.sleep(POLL_SECONDS)
        
        except KeyboardInterrupt:
            print("\n\n🛑 COLLECTOR STOPPED!")
            ssh.close()
            break
        except Exception as e:
            print(f"⚠️  Temporary error: {e}")
            time.sleep(2)

if __name__ == "__main__":
    main()