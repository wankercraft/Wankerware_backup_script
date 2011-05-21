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
#****************************VARIABLES****************************
#
#********************MAP MAKING VARIABLES********************
#*************REQUIRES MINECRAFT_OVERVIEWER*************
#Set to 1 if you want to run the map making portion of the script.
MAP=1

#This variable defines the directory for your map making program    example: /home/username/Minecraft_Overviewer/
MAPPER=

#Set this variable to the directory you want to save your map in.    example: /home/username/web_directory/map/
MAPDIR=

#Set this variable to the primary folder you want the cache files saved to.    example: /home/username/web_directory/map/cache/
MAPCACHE=

#Set this variable to your primary world directory.     example: /home/username/minecraft_directory/world/
WORLD="/home/dachroni/minecraft/wankercraft_bukkit9.0/wankercraft/"

#**********THESE VARIABLES ARE FOR MULTIPLE WORLDS NEEDING MAPS ALSO (YOU CAN MAKE AS MANY AS YOU LIKE)*********

#Set this variable to the directory you want to use for your second world map.    example: /home/username/web_directory/map2/
MAPDIRALT=

#Set this variable to the directory you want to use for your second world cache files.    example: /home/username/web_directory/map2/cache/
MAPCACHEALT=

#Set this variable to your secondary world directory.    example: /home/username/minecraft_directory/world2/
WORLDALT=


#********************SERVER BACKUP VARIABLES********************

#Set to 1 if you want the script to backup the server directory.
BACKUP=1

#Set this variable to your minecraft server directory. Default /home/username/minecraft_directory/
DIRECTORY=

#Set this variable to the directory you wish to use for your backups.    example: /home/username/minecraft_backup/
BACKUPDIR=

#Tarball Variable
TAR="tar czf `date +%d-%m-%Y_%H%M%S`.tar.gz /home/username/backup_directory/minecraft_server_directory/"

#Set to 1 if you want to announce backup progress on the server console
NOTIFY=1

#Set to 1 if you want to save to current world state on the server before compression
SAVE=1

#Name of the screen session the server is running in. Default is "smp"
SCREEN="smp"

#********************CRON SCRIPT********************


#Set to 1 of you want to add a new entry to your crontab (if allowed)
#CRON=0

#Set for how often to backup in minutes ie.. 60, 120, etc... (Recommend every 6 hours at most. The files can get large.)
#BACKUPTIME=360

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
				screen -x $SCREEN -X stuff "`printf "say Backing up server..\r"`"
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
		echo Copying current server directory
			cp -R "$DIRECTORY" "$BACKUPDIR"
		echo Copying of current server directory complete
fi


#THIS SECTION COMPRESSES THE CURRENT BACKUP OF THE MINECRAFT SERVER DIRECTORY INTO TAR.GZ FORMAT


if [ $BACKUP -eq 1 ]
	then
		echo Compressing current server directory
			$TAR
		echo Compression of current server directory complete
		sleep 1
		echo Removing Raw Minecraft directory #THIS PART REMOVES COPIED SERVER DIRECTORY
#       THE DIRECTORY BELOW NEEDS TO BE $BACKUPDIR/minecraft_server_directory. That should work. I just use the whole address ie.
#       /home/username/backup_directory/minecraft_server_directory/ .  This should be cleaner I'm sure. I barely know this stuff atm though.*************
		rm -R /home/username/backup_directory/minecraft_server_directory/
		echo Raw directory has been removed
fi


if [ $NOTIFY -eq 1 ]
	then
		screen -x $SCREEN -X stuff "`printf "say Server backup complete.\r"`"
		sleep 1
	echo World of Wankercraft backup complete
fi


# --Cron Job Install--
#if [ $CRON -eq 1 ]
#then
#
#  #Check if user can use crontab
#   if [ -f "/etc/cron.allow" ]
#   then
#      EXIST=`grep $USER < /etc/cron.allow`
#      if [ "$EXIST" != "$USER" ]
#      then
#         echo "Sorry. You are not allowed to edit cronjobs."
#         exit
#      fi
#   fi

   #Work out crontime
   #if [ $BACKUPTIME -eq 0 -o $BACKUPTIME -lt 0 ]
#   then
#      MINS="*"
#   else
#      MINS="*/$BACKUPTIME"
#   fi
#
   #Check if cronjob exists, if not then create.
#   crontab -l > .crons
#   EXIST=`crontab -l | grep $0 | cut -d";" -f2`
#   CRONSET="$MINS * * * * cd $PWD;$0"

#   if [ "$EXIST" == "$0" ]
#   then

      #Check if cron needs updating.
#      THECRON=`crontab -l | grep $0`
#      if [ "$THECRON" != "$CRONSET" ]
#      then
#         CRONS=`crontab -l | grep -v "$0"`
#         echo "$CRONS" > .crons
#         echo "$CRONSET" >> .crons
#         crontab .crons
#         echo "Cronjob has been updated"
#      fi

#      rm .crons
#      exit
#   else
#      crontab -l > .crons
#      echo "$CRONSET" >> .crons
#      crontab .crons
#      rm .crons
#      echo "Autobackup has been installed."
#      exit
#   fi

#fi



#********************MAP MAKING SCRIPT********************

if [ $MAP -eq 1 ]
	then
		if [ $NOTIFY -eq 1 ]
			then
				screen -x $SCREEN -X stuff "`printf "say Updating map. Things could get a bit laggy.\r"`"
			sleep 1
		fi
		echo Updating world map
		cd "$MAPPER"
		python26 gmap.py --lighting --cachedir="$MAPCACHE" "$WORLD" "$MAPDIR"
		sleep 1
		screen -x $SCREEN -X stuff "`printf "say Finished updating the first map. Took long enough.\r"`"
		sleep 2
		python26 gmap.py --lighting --cachedir="$MAPCACHEALT" "$WORLDALT" "$MAPDIRALT"
		sleep 1
		screen -x $SCREEN -X stuff "`printf "say Finished updating the second map. Took long enough.\r"`"
		sleep 1
		echo World maps updated
		echo Server map has been updated
	else
		screen -x $SCREEN -X stuff "`printf "say Map is not being updated this time.\r"`"
		sleep 1
		echo Map not being updated
fi
