#!/bin/sh

clear
initialEChar="\033["

BOLD="${initialEChar}1m"
UNDERLINE="${initialEChar}4m"
NORMAL="${initialEChar}0m"
RED="${initialEChar}1;31m"

menu() {

	convert() {

		echo

		erasedInitialPart=$(
			sed "/TITLE: /d" "$1" |
			sed "/FCM: /d"
		)
		timeCodes=$(echo "$erasedInitialPart" | grep "001")
		descsOfChapters=$(echo "$erasedInitialPart" | grep "|M")
		listOfTimeCodes=()
		listOfDescsOfChapters=()

		echo "$timeCodes" | {

			while read line; do
				listOfTimeCodes+=($(echo "$line" | pcregrep -o1 "\s\s[0-9]*:([0-9]*:[0-9]*):[0-9]*"))
			done
			
			
			echo "$descsOfChapters" | {

				while read line2; do
					listOfDescsOfChapters+=("$(echo "$line2" | pcregrep -o1 "\|M:(.*) \|D:1")")
				done
				

				for n in ${!listOfTimeCodes[*]}; do
					echo ${listOfTimeCodes[n]} "${listOfDescsOfChapters[n]}"
				done

			}

		}
		read -n 1
		echo
		exit
	}


	clear
	cd ~/Desktop

	echo Put in the path to the ${BOLD}${UNDERLINE}edl$NORMAL file needed
	echo ${RED}q$NORMAL to quit
	echo

	read -e -p "Your path: " answer

	[[ $answer == "" ]] && menu
	[[ $answer == "q" ]] && exit
	[[ $answer != "" ]] && {

		ls "$answer" &>/dev/null && convert "$answer" || {
			clear
			echo ${RED}Couldn\'t find any actual file.$NORMAL
			read
		}

	}	
	menu

}
menu
