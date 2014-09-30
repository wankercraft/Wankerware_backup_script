#!/bin/sh
#Wankerware Backup and Map Generation Script v3.0
#Written by Wankerpants
#Parts inspired by "MINECRAFT Autobackup By Justin Smith". Especially the cron job section.
#
#		   This Script is in the Public Domain. Do what you want with it.
#
#			   
#			
#
#
#
#********************VARIABLES********************

#********************SERVER BACKUP VARIABLES********************

#Set to 1 if you want the script to backup the server directory
BACKUP=1

#Set this variable to your server directory, default /home/yourusername/minecraft/
DIRECTORY="/home/dachroni/minecraft/wankercraft/"

#Set this variable to the directory you wish to use for your backups
BACKUPDIR="/home/dachroni/minecraft/backup/wankercraft_main"

#Tarball Variable
TAR="tar czf `date +%d-%m-%Y_%H%M%S`.tar.gz /home/dachroni/minecraft/backup/wankercraft_main"

#Set to 1 if you want to announce backup progress on the server console
NOTIFY=1

#Set to 1 if you want to save to current world state on the server before compression
SAVE=1

#Name of the screen session the server is running in
SCREEN="smp"


#********************SERVER BACKUP SCRIPT********************

if [ $BACKUP -eq 1 ]
	then
		sleep 2
	else
		exit
fi

#This part forces a save in the server

if [ $SAVE -eq 1 ]
	then
		if [ $NOTIFY -eq 1 ] #Announces to server a save is taking place
			then
				screen -x $SCREEN -X stuff "`printf "say Backing up World of Wankercraft..\r"`"
				sleep 1
		fi
		echo Forcing server save
fi


if [ $SAVE -eq 1 ] #Forcing save on the server
then
   screen -x $SCREEN -X stuff `printf "save-all\r"`
   sleep 2
fi


if [ $SAVE -eq 1 ] #Announces to server the save is complete
	then
	echo Server save complete
fi


#THIS SECTION COPIES CURRENT MINCRAFT SERVER DIRECTORY TO THE BACKUP DIRECTORY


if [ $BACKUP -eq 1 ] #Copies over current minecraft server directory to the backup directory
	then
		echo Copying current Wankercraft directory
			cp -R "$DIRECTORY" "$BACKUPDIR"
		echo Copying of current Wankercraft directory complete
fi


#THIS SECTION COMPRESSES THE CURRENT BACKUP OF THE MINECRAFT SERVER DIRECTORY INTO TAR.GZ FORMAT


if [ $BACKUP -eq 1 ]
	then
		echo Compressing current Wankercraft directory
			cd /home/dachroni/minecraft/backup/
			$TAR
#			sleep 1
#			tar czf herpderp.tar.gz /home/dachroni/minecraft/backup/wankercraft_main
######################## connect via scp ############################################
#spawn scp -p "wankerpants@wankercraft.tk:/home/wankerpants/" herpderp.tar.gz
#####################
#	expect {
#		-re ".*es.*o.*" {
#			exp_send "yes\r"
#			exp_continue
#		}
#		-re ".*sword.*" {
#			exp_send "qt1ps0scar\r"
#		}
#	}
#	interact
#######################################################################################
#			sleep 1
#			rm -rf herpderp.tar.gz
			sleep 1
		echo Compression of current Wankercraft directory complete 
		sleep 1
		echo Removing Raw Minecraft directory #THIS PART REMOVES COPIED SERVER DIRECTORY
		rm -R -v /home/dachroni/minecraft/backup/wankercraft_main/
		echo Raw directory has been removed
fi


if [ $NOTIFY -eq 1 ]
	then
		screen -x $SCREEN -X stuff "`printf "say World of Wankercraft backup complete.\r"`"
		sleep 1
	echo World of Wankercraft backup complete
fi
