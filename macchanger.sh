#!/bin/bash
sudo apt  install  espeak -y
clear
# Function to display the colorful loading effect
show_loading() {
  local duration="$1"  # Duration of the loading effect in seconds
  local interval=0.2   # Time interval between each frame in seconds
  local symbols=("◐" "◓" "◑" "◒")  # You can add more symbols to the array for variation
  local colors=("\\e[96m" "\\e[92m" "\\e[93m" "\\e[91m")  # Cyan, Green, Yellow, Red

  for ((i = 0; i < duration * 5; i++)); do
    local symbol="${symbols[i % 4]}"
    local color="${colors[i % 4]}"
    echo -ne "${color}Loading... $symbol\\e[0m\r"
    sleep "$interval"
  done
}

# Usage example: Display the loading effect for 5 seconds
show_loading 5
echo "Loading complete!"
sleep 2
clear

echo  "                                          "
echo  "                 .o888P      Y8o8Y      Y888o. "
echo  "                d88888       88888      88888b "
echo  "                d888888b_  _d88888b_  _d888888b "
echo  "                8888888888888888888888888888888 "
echo  "                8888888888888888888888888888888 "
echo  "                YJGS8P'Y888P'Y888P'Y888P'Y8888P "
echo  "                 Y888   '8'   Y8P   '8'   888Y "
echo  "                  '8o          V          o8' "
echo  "    `                     `"
echo  "              Welcome to MacChanger -$ "
echo  "               by StRaNgErDreAmEr "
espeak " welcome user"
# Function to change MAC address for the specified network interface
change_mac_address() {
  interface="$1"
  sudo macchanger -l > vendormac.txt
  ouimac=$(shuf -n 1 vendormac.txt | awk '{print$3}')
  uaamac=$(printf '%02x:%02x:%02x' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])
  echo "MAC address has been changed to $ouimac:$ouimac"
  sudo macchanger -m "$ouimac:$ouimac" "$interface"
}

# Get a list of available network interfaces
interfaces=($(ip -o link show | awk -F': ' '{print $2}'))

# Display a menu for selecting the network interface
PS3="Enter the number corresponding to the network interface you want to change the MAC address for: "
select interface in "${interfaces[@]}"; do
  if [[ -n "$interface" ]]; then
    change_mac_address "$interface"
    sleep 2
    rm MacChanger
    git clone  https://github.com/strangedreamer4/MacChanger.git
    cd MacCahger
    chmod +x macchanger.sh
    ./macchanger.sh
    clear
    break
  else
    espeak " Invalid option "
    echo "Invalid option. Please select a valid number."
  fi
done
