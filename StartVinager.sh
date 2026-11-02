#!/bin/bash
filesishere=./testing.sh
konsole -e $filesishere 
logwc=$(cat $PWD/log.log | wc -l )  && (($logwc > 100 )) && echo "none" > $PWD/log.log
flatpak run org.vinegarhq.Vinegar