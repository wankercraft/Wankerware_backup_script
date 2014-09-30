#!/bin/sh
#********************MAP MAKING VARIABLES********************

#Set to 1 if you want to run the map making portion of the script *****requires Minecraft_Overviewer 0.9 or later*****
MAP=1

NOTIFY=1

#Set this variable to your world directory
WORLD="/home/dachroni/minecraft/wankercraft/"

#Set this directory to the main directory that will contain your temp world directory
TEMPROOT="/home/dachroni/minecraft/backup"

#Set this variable to your temporary map storage directory created at the begining of the script
MAPTEMP="/home/dachroni/minecraft/backup/map_worlds"

SCREEN="smp"
##############################################################################################################################
##############################################################################################################################


if [ $MAP -eq 1 ]
	then
		if [ $NOTIFY -eq 1 ]
			then
				screen -x $SCREEN -X stuff "`printf "say Updating maps. Things could get a bit laggy.\r"`"
			sleep 1
		fi

###############THIS SECTION CREATES A TEMP MAP DIRECTORY, AND COPIES THE WORLDS TO THAT DIRECTORY################
		echo Creating temp world map directoy
		cd $TEMPROOT
		mkdir map_worlds
		cd $WORLD
		cp -R -p wankercraft/ $MAPTEMP
#		cp -R -p Originalwank/ $MAPTEMP

###############THIS SECTION RUNS THE MAPPING PROGRAM THEN REMOVES THE TEMP WORLD DIRECTORY##################################################
		echo Updating world map
		cd $MAPTEMP
		overviewer.py --config=/home/dachroni/minecraft/overviewer_config/mapconfig.py
		sleep 1
		overviewer.py --config=/home/dachroni/minecraft/overviewer_config/mapconfig.py --genpoi
		screen -x $SCREEN -X stuff "`printf "say Finished updating the maps. Took long enough.\r"`"
		sleep 1
		echo World maps updated
		echo World of Wankercraft Map has been updated
		cd $TEMPROOT
		rm -R map_worlds/
	else 
		screen -x $SCREEN -X stuff "`printf "say Map is not being updated this time.\r"`"
		sleep 1
		echo Map not being updated
fi
