#!/bin/bash
#Assignment 1
#Author: Emily VanDerveer
#This script locates executeable files. It takes a list of file names
#from the command line and determines which would be executed had these
#names be given as commands.
#
#usage: mywhich [-a] command ...
#
# -a is a flag that will check for all occurances of the command
# by default it will only find the first occurance

FINDALL=FALSE				#-a flag
FOUND=FALSE					#alerts file was found
ONEFOUND=FALSE				#flag to ensure only one is found if FINDALL=FALSE

function isExec () {
	ls "$path" | grep -q "$file"				#searches files inside path for filename
	if [ $? -eq 0 ]
	then
		if [ -x "$path/$file" -a ! -d "$path/$file" ]  #ensure file is exectuable and not a dir
		then
			FOUND=TRUE
			ONEFOUND=TRUE							
			echo "$path/$file"
		else
			:
		fi
	else
		FOUND=FALSE
	fi
}

function testSelf () {
	echo "$file" | grep -q '/'					#searches if file variable has a '/'
		if [ $? -eq 0 ]
		then
			if [ -x "$file" -a ! -d "$file" ]	#ensures file is executable and not a dir
			then 
				ONEFOUND=TRUE
				echo "$file"
				continue
			fi
		fi
		for path in ${PATH//:/ }				# Loops through $PATH variable
			do
				echo "$path" | grep -q "$file"		#Tests if pathname is filename
				if [ $? -eq 0 ]
				then
					if [ -x "$file" -a ! -d "$file" ]
					then
						FOUND=TRUE
						ONEFOUND=TRUE
						echo "$file"
					else
						:
					fi				
				else
					FOUND=FALSE 
				fi
			done

}

testInside () {
				for path in ${PATH//:/ }				#Loops through $PATH variable
				do
					if [ $FOUND = TRUE -a $FINDALL = FALSE ]	#Continue to next loop if file was already matched
					then
						continue
					elif [ $FOUND = TRUE ]					#FINDALL flag was set to -a
					then
						ONEFOUND=TRUE
						isExec
						if [ $FOUND = FALSE ] 				#Discontinue loop once all have been found
						then
							continue
						fi
					else
						isExec
					fi
				done
				if [ $ONEFOUND = FALSE ]
					then
					echo "$file is not found"
				fi
}


while :			#handles flag options
	do
	case $1 in
	-a)
		FINDALL=TRUE
		shift # deletes this argument
		;;
	-h)
		echo "Usage: $0 [-a] commands"
		echo "If -a is used $0 will check for all occurances"
		exit 0
		;;
	*)			#anything else
		break
		;;
	esac
done




for file in "$@"
	do
		FOUND=FALSE
		ONEFOUND=FALSE
		testSelf
		testInside
	done

for file in "$@"
	do
		FOUND=FALSE
		ONEFOUND=FALSE
 		#testInside
	done