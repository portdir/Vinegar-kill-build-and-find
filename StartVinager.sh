#!/bin/bash
filesishere=./testing.sh
konsole -e $filesishere &&
konsole -e flatpak run org.vinegarhq.Vinegar &
exit 1