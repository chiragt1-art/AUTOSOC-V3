from flask import Flask, render_template_string
import json
import os
import time
from collections import Counter
from datetime import datetime

app = Flask(__name__)

# Path to alerts file
ALERTS_FILE = os.path.join(os.getcwd(), "logs", "alerts.json")

def load_alerts():
    if os.path.exists(ALERTS_FILE):
        try:
            with open(ALERTS_FILE, 'r') as f:
                return json.load(f)
        except:
            return []
    return []

@app.route('/')
def dashboard():
    alerts = load_alerts()
    total_alerts = len(alerts)
    
    # Exact metrics from your screenshot
    metrics = {
        "response_time": 12,
        "processing_time": 16,
        "queue_length": 20,
        "active_connections": 16,
        "total_alerts": total_alerts  # New live alerts metric
    }
    
    # Chart data (matches your screenshot)
    bar_chart_data = [12, 15, 10, 18, 14, 16, 13]
    line_chart_data = [8, 10, 7, 12, 9, 15, 18]
    heatmap_data = [90, 75, 85, 60, 95, 80, 70, 100, 65, 88]
    
    # Severity pie chart
    severity_counts = {
        "Critical": sum(1 for a in alerts if a.get('severity') == 'CRITICAL'),
        "High": sum(1 for a in alerts if a.get('severity') == 'HIGH'),
        "Medium": sum(1 for a in alerts if a.get('severity') == 'MEDIUM'),
        "Low": sum(1 for a in alerts if a.get('severity') == 'LOW')
    }
    
    # Recent alerts
    recent_alerts = alerts[-10:]
    
    # HTML template with live alerts section
    html = '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoSOC - Exact Dashboard Match</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
            body { background: #0a0a0a; color: #ffffff; }
            .header { background: #1a1a1a; padding: 10px 20px; border-bottom: 1px solid #333; display: flex; justify-content: space-between; align-items: center; }
            .live-alerts-badge { background: #ff4444; color: white; padding: 8px 16px; border-radius: 20px; font-size: 16px; font-weight: 700; }
            .metric-bar { display: flex; justify-content: space-around; background: #1a1a1a; padding: 15px 0; border-bottom: 1px solid #333; }
            .metric-card { text-align: center; }
            .metric-value { font-size: 28px; font-weight: 700; color: #00ff88; margin-bottom: 5px; }
            .metric-label { font-size: 14px; color: #cccccc; text-transform: uppercase; }
            .dashboard-grid { display: grid; grid-template-columns: 1fr 2fr 1fr; gap: 15px; padding: 15px; }
            .panel { background: #1a1a1a; border-radius: 8px; padding: 15px; border: 1px solid #333; }
            .panel-title { font-size: 14px; color: #cccccc; margin-bottom: 10px; text-transform: uppercase; }
            .pie-chart-container { height: 180px; }
            .bar-chart-container { height: 180px; }
            .heatmap { display: flex; justify-content: space-around; align-items: flex-end; height: 120px; margin-top: 10px; }
            .heatmap-bar { width: 25px; border-radius: 4px 4px 0 0; }
            .list-container { height: 180px; overflow-y: auto; }
            .list-item { padding: 8px 0; border-bottom: 1px solid #333; font-size: 13px; color: #cccccc; }
            .line-chart-container { height: 180px; grid-column: 1 / span 3; margin-top: 15px; }
            .footer { text-align: center; padding: 10px; color: #666; font-size: 12px; border-top: 1px solid #333; }
        </style>
    </head>
    <body>
        <div class="header">
            <h2>AutoSOC Real-Time Monitoring</h2>
            <!-- NEW LIVE ALERTS SECTION -->
            <div class="live-alerts-badge">
                🚨 LIVE ALERTS: {{ metrics.total_alerts }}
            </div>
        </div>
        
        <div class="metric-bar">
            <div class="metric-card">
                <div class="metric-value">{{ metrics.response_time }}</div>
                <div class="metric-label">12 min</div>
            </div>
            <div class="metric-card">
                <div class="metric-value">{{ metrics.processing_time }}</div>
                <div class="metric-label">16 min</div>
            </div>
            <div class="metric-card">
                <div class="metric-value">{{ metrics.queue_length }}</div>
                <div class="metric-label">20 min</div>
            </div>
            <div class="metric-card">
                <div class="metric-value">{{ metrics.active_connections }}</div>
                <div class="metric-label">16</div>
            </div>
        </div>
        
        <div class="dashboard-grid">
            <!-- Left Panel: Pie Chart + Heatmap -->
            <div class="panel">
                <div class="panel-title">Severity Distribution</div>
                <div class="pie-chart-container">
                    <canvas id="pieChart"></canvas>
                </div>
                <div class="panel-title">Threat Heatmap</div>
                <div class="heatmap">
                    {% for value in heatmap_data %}
                    <div class="heatmap-bar" style="height: {{ value }}%; background: {{ '#ff4444' if value > 80 else '#ffaa00' if value > 60 else '#00ff88' }};"></div>
                    {% endfor %}
                </div>
            </div>
            
            <!-- Middle Panel: Bar Chart + List -->
            <div class="panel">
                <div class="panel-title">Attack Frequency</div>
                <div class="bar-chart-container">
                    <canvas id="barChart"></canvas>
                </div>
                <div class="panel-title">Recent Alerts</div>
                <div class="list-container">
                    {% for alert in recent_alerts %}
                    <div class="list-item">{{ alert.attack_type[:30] }}...</div>
                    {% endfor %}
                </div>
            </div>
            
            <!-- Right Panel: Activity List -->
            <div class="panel">
                <div class="panel-title">System Activity</div>
                <div class="list-container">
                    <div class="list-item">Connection established</div>
                    <div class="list-item">Alert processed</div>
                    <div class="list-item">Database updated</div>
                    <div class="list-item">Threat detected</div>
                    <div class="list-item">Rule applied</div>
                    <div class="list-item">Log rotated</div>
                    <div class="list-item">API request</div>
                    <div class="list-item">Status check</div>
                </div>
            </div>
        </div>
        
        <!-- Bottom Line Chart -->
        <div class="panel line-chart-container">
            <div class="panel-title">Performance Trend</div>
            <canvas id="lineChart"></canvas>
        </div>
        
        <div class="footer">
            AutoSOC v3.0 | Last Updated: {{ current_time }} | Auto-refresh every 5 seconds
        </div>
        
        <script>
            // Pie Chart
            const pieCtx = document.getElementById('pieChart').getContext('2d');
            new Chart(pieCtx, {
                type: 'pie',
                data: {
                    labels: ['Critical', 'High', 'Medium', 'Low'],
                    datasets: [{
                        data: [{{ severity_counts.Critical }}, {{ severity_counts.High }}, {{ severity_counts.Medium }}, {{ severity_counts.Low }}],
                        backgroundColor: ['#ff4444', '#ffaa00', '#00aaee', '#00ff88']
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });
            
            // Bar Chart
            const barCtx = document.getElementById('barChart').getContext('2d');
            new Chart(barCtx, {
                type: 'bar',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    datasets: [{
                        data: {{ bar_chart_data }},
                        backgroundColor: '#00aaee'
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true } } }
            });
            
            // Line Chart
            const lineCtx = document.getElementById('lineChart').getContext('2d');
            new Chart(lineCtx, {
                type: 'line',
                data: {
                    labels: ['1', '2', '3', '4', '5', '6', '7'],
                    datasets: [{
                        data: {{ line_chart_data }},
                        borderColor: '#00ff88',
                        backgroundColor: 'rgba(0, 255, 136, 0.1)',
                        fill: true
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true } } }
            });
            
            // Auto-refresh
            setInterval(() => window.location.reload(), 5000);
        </script>
    </body>
    </html>
    '''
    
    return render_template_string(html,
                                  metrics=metrics,
                                  bar_chart_data=bar_chart_data,
                                  line_chart_data=line_chart_data,
                                  heatmap_data=heatmap_data,
                                  severity_counts=severity_counts,
                                  recent_alerts=recent_alerts,
                                  current_time=datetime.now().strftime('%H:%M:%S'))

if __name__ == '__main__':
    app.run(debug=True, port=5000)