#!/bin/bash 
clear

health=10

## term array 
bank_trm=('SIGHUP(1)' 'SIGINT(2)' 'SIGQUIT(3)' 'SIGTERM(15)' 'SIGKILL(9)' 'SIGCONT(18)' 'SIGSTOP(19)' 'SIGTSTP(20)' 'STIGSR1(10)/STIGUSR2(12)')

## Health check
health_chck(){
	if [[ $health -lt 1 ]]; then 
		clear
		printf "DAMN YOUR STUPID \n "
		exit 1
	elif [[ $health -gt 10 ]]; then
		health=10 
		continue 
	fi 
}

## answer check
check(){

	## Correct answer check
	if [[ $answer == "c" ]]; then 
		health=$((health + 1))  ## add from health
		health_chck 
		printf "\n Nice!" 

	elif [[ $answer == "w" ]]; then 
		health=$((health - 1))  ## sub from health
		health_chck
		printf "\n big oof health is now: $health \n" 
	elif [[ $answer == "x" ]]; then
		clear
		printf "see you later looser! \n"
		exit 1
	fi
}

## user input 
while true; do

	clear
	## random pick term
	rnd=$(( RANDOM % ${#bank_trm[@]} ))

	printf "your health is: $health \n"
	read -p "what is ${bank_trm[$rnd]} inputs(x,c,w)" answer
	check
done
