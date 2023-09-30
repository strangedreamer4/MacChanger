#!/bin/bash

# Function to display the colorful loading effect
show_loading() {
  local duration="$1"
  local interval=0.2
  local symbols=("◐" "◓" "◑" "◒")
  local colors=("\e[96m" "\e[92m" "\e[93m" "\e[91m")

  for ((i = 0; i < duration * 5; i++)); do
    local symbol="${symbols[i % 4]}"
    local color="${colors[i % 4]}"
    echo -ne "${color}Loading... $symbol\e[0m\r"
    sleep "$interval"
  done
}

# Function to change MAC address for the specified network interface
change_mac_address() {
  local interface="$1"
  
  # Bring the interface down
  sudo ip link set "$interface" down
  
  # Change the MAC address
  sudo macchanger -l > vendormac.txt
  local ouimac=$(shuf -n 1 vendormac.txt | awk '{print $3}')
  local uaamac=$(printf '%02x:%02x:%02x' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
  echo "MAC address has been changed to $ouimac:$uaamac"
  sudo macchanger -m "$ouimac:$uaamac" "$interface"
  
  # Bring the interface back up
  sudo ip link set "$interface" up
}

# Display a welcome message
clear
echo "                                          "
echo "                 .o888P      Y8o8Y      Y888o. "
echo "                d88888       88888      88888b "
echo "                d888888b_  _d88888b_  _d888888b "
echo "                8888888888888888888888888888888 "
echo "                8888888888888888888888888888888 "
echo "                YJGS8P'Y888P'Y888P'Y888P'Y8888P "
echo "                 Y888   '8'   Y8P   '8'   888Y "
echo "                  '8o          V          o8' "
echo "    \`                     \`"
echo "              Welcome to MacChanger -\$ "
echo "               by StRaNgErDreAmEr "
espeak "Welcome user"

# Install espeak silently
sudo apt install espeak -y > /dev/null 2>&1

# Additional code snippet
# ALSA lib pcm.c errors

killall jackd > /dev/null 2>&1

while true; do
  # Check for local changes in machanger.sh
  if [[ $(git diff machanger.sh) ]]; then
    # Local changes found
    echo "Local changes detected in machanger.sh."
    echo "Do you want to commit, stash your local changes, or exit? (commit/stash/exit)"
    read choice

    case "$choice" in
      "commit")
        # Commit your local changes
        git add machanger.sh
        git commit -m "Committing local changes to machanger.sh"
        ;;
      "stash")
        # Stash your local changes
        git stash
        ;;
      "exit")
        echo "Exiting the script."
        exit
        ;;
      *)
        echo "Skipping update due to local changes."
        ;;
    esac
  fi

  # Perform the pull to update the script
  git pull

  # Get a list of available network interfaces
  interfaces=($(ip -o link show | awk -F': ' '{print $2}'))

  # Display a menu for selecting the network interface or exiting
  PS3="Enter the number corresponding to the network interface you want to change the MAC address for (or '0' to exit): "
  select interface in "${interfaces[@]}"; do
    if [[ "$REPLY" == "0" ]]; then
      echo "Exiting the script."
      exit
    elif [[ -n "$interface" ]]; then
      change_mac_address "$interface"
      sleep 5
      break
    else
      espeak "Invalid option"
      echo "Invalid option. Please select a valid number or '0' to exit."
    fi
  done
done

# Add an exit message here (this will only be reached if the user exits the script)
echo "Script finished running. Exiting."
