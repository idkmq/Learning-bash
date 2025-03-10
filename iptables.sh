#!/bin/bash

##input
arg=$1

rule_check(){

	printf "\n"
	printf "###################"
	printf " [+] PRINTING RULES:"
	iptables -nvL --line-numbers
}

clear
apply_rules(){
	###### INPUT RULES
	printf "\n"
	printf "###################"
	printf " [+] APPLYING INPUT RULES"

	iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
	iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -p icmp -j ACCEPT
	iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
	iptables -A INPUT -p tcp --dport 2222 -m conntrack --ctstate NEW -m comment --comment "CUSTOM SSH ALLOW" -j ACCEPT
	iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW -m comment --comment "HTTP/HTTPS" -j ACCEPT

	printf "\n"
	printf "###################"
	printf " [+] INPUT RULES HAVE BEEN APPLIED"
	sleep 2

	###### OUTPUT RULES
	printf "\n ###################"
	printf " [+] APPLYING OUTPUT RULES"

	iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT  
	iptables -A OUTPUT -m conntrack --ctstate INVALID -j DROP  
	iptables -A OUTPUT -o lo -j ACCEPT  
	iptables -A OUTPUT -p icmp -j ACCEPT  
	iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 2222 -m comment --comment "CUSTOM SSH ALLOW" -j ACCEPT
	iptables -A OUTPUT -p tcp -m multiport --dports 80,443,53 -m conntrack --ctstate NEW -j ACCEPT  
	iptables -A OUTPUT -p udp -m multiport --dports 53,123 -j ACCEPT

	printf "\n"
	printf "###################"
	printf " [+] OUTPUT RULES HAVE BEEN APPLIED"
	sleep2

	printf "\n"
	printf "###################"
	printf " [+] PRINTING APPLIED RULES:"

	printf "\n"
	iptables -nvL --line-numbers
}

drop(){
	iptables -P INPUT DROP ;iptables -P OUTPUT DROP ;iptables -P FORWARD DROP
	printf "\n"
	printf "###################"
	iptables -nvL --line-numbers
}


accept(){
	iptables -P INPUT ACCEPT ;iptables -P OUTPUT ACCEPT ;iptables -P FORWARD ACCEPT
	printf "\n"
	printf "###################"
	iptables -nvL --line-numbers
}

main(){
	clear

	if [[ -z $arg ]]; then 
	    echo "USAGE: ./script <apply>/<drop>/<accept>"
	    sleep 2
	    exit 1
	elif [[ $arg == "apply" ]]; then
	    apply_rules

	elif [[ $arg == "drop" ]]; then 
	    drop
	elif [[ $arg == "accept" ]]; then 
		accept
	else
	    echo "Invalid option: $arg"
	    echo "USAGE: ./script <apply>/<drop>"
	    exit 1
	fi
}

main