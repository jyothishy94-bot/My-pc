#!/usr/bin/env bash
set -e

echo "Updating system and installing XFCE desktop & noVNC tools..."
sudo apt-get update && sudo apt-get install -y \
  xfce4 xfce4-goodies \
  xvfb \
  novnc x11vnc \
  net-tools \
  curl git python3-pip

# Kill any existing sessions
pkill -f Xvfb || true
pkill -f x11vnc || true
pkill -f novnc || true

# Start Virtual Framebuffer on display :1
export DISPLAY=:1
Xvfb :1 -screen 0 1280x720x24 &
sleep 2

# Start XFCE window manager
startxfce4 &
sleep 2

# Start VNC server on port 5900
x11vnc -display :1 -nopw -forever -shared -bg -rfbport 5900
sleep 1

# Start noVNC web proxy forwarding port 5900 to 6080
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

echo "=================================================="
echo "Linux Desktop is running!"
echo "1. Go to the 'Ports' tab at the bottom of VS Code."
echo "2. Find Port 6080 and set visibility to PUBLIC."
echo "3. Click the globe icon next to Port 6080 to open."
echo "=================================================="
