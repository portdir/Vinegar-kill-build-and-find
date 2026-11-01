#!/bin/bash
##############################################################
# about
MADE_BY="Casts" # 
PRO_VERSION="v5.0.1" # 
PRO_ABOUT="" # 

##############################################################
# data
FLATPAK_ID="org.vinegarhq.Vinegar" # 
VINEGAR_DIR="$HOME/.var/app/$FLATPAK_ID" # where its installed
BACKUP_DIR="$HOME/RBXbackup/data/vinegar" # backups go's here
DATA_TARGET="$HOME/.var/app/$FLATPAK_ID/data/vinegar" #
RMDIRflatpak="$HOME/.local/share/flatpak/app/$FLATPAK_ID"

##############################################################
echo -e "
MADE_BY
$MADE_BY
PRO_VERSION
$PRO_VERSION
PRO_ABOUT
$PRO_ABOUT

FLATPAK_ID
$FLATPAK_ID
VINEGAR_DIR
$VINEGAR_DIR
BACKUP_DIR
$BACKUP_DIR
DATA_TARGET
$DATA_TARGET
RMDIRflatpak
$RMDIRflatpak
"
#
MAKE_LINE(){
    printf %"$COLUMNS"s|tr " " "-"
};

cleanup(){
    echo -e "\n[STOPPING]\n"
    flatpak kill "$FLATPAK_ID" &>/dev/null || true
    kill -- -$$ 2>/dev/null || true &
    trap - INT TERM
    exit 1
};
trap cleanup INT TERM

UNINSTALL_Vinegar(){
    # uninstalls Vinegar
    MAKE_LINE
    flatpak uninstall -y --delete-data $FLATPAK_ID
    flatpak uninstall -y --delete-data $FLATPAK_ID.Locale

    if [ -d "$VINEGAR_DIR" ]; then
    mv --force  "$VINEGAR_DIR" "$VINEGAR_DIR/../DEL.$FLATPAK_ID"
    else
    echo no file 1 "$VINEGAR_DIR"
    fi
    
    # if [ -d "$RMDIRflatpak" ]; then
    # rm -rf $RMDIRflatpak
    # else
    # echo no file 2 $RMDIRflatpak 
    # fi
};

INSTALL_Vinegar(){
# builds Vinegar
MAKE_LINE
echo -e "installing $FLATPAK_ID for $USER\n"
flatpak install  -y flathub "$FLATPAK_ID"
MAKE_LINE
echo -e " making config.toml for $USER\n"
# config.toml
mkdir -p "$VINEGAR_DIR/config/vinegar"
cat <<EOF > "$VINEGAR_DIR/config/vinegar/config.toml"
debug = true

[studio]
channel = "LIVE"
discord_rpc = false 
renderer = "Vulkan"
webview = ""
[studio.env]
PROTON_ENABLE_WAYLAND = "1"
EOF

};

RUN_Vinegar_FOR_SETUP(){
    # runs Vinegar so i can kill it later with Prejudice
    konsole -e flatpak run $FLATPAK_ID & 
    sleep 2
    flatpak kill "$FLATPAK_ID" &>/dev/null || true
};

MAKE_BACKUP_FILES(){
# make sure that the file are there
mkdir -pf $BACKUP_DIR $DATA_TARGET

# git the rbx appdata from your file
if [ -d "$VINEGAR_DIR/data/vinegar/appdata" ]; then
mv --force $VINEGAR_DIR/data/vinegar/appdata $BACKUP_DIR/
else
echo no file 3 $VINEGAR_DIR/data/vinegar/appdata
fi
};

COPY_BACKUP_OVER(){
#take from backup move back to RBXs
mkdir -p $BACKUP_DIR $DATA_TARGET
cp -rf $BACKUP_DIR/* $DATA_TARGET
};

echo -e "
$(MAKE_LINE)
# Vinegar sucks ass for one the gay guy. 
# $MADE_BY
# $PRO_VERSION
$(MAKE_LINE)
Grab Vinegar/roblox data from last session? [Y/N] or hit enter
$(MAKE_LINE)
"

read -p "[Y/N]-->" yesno
if [[ $yesno =~ ^([Yy][Ee][Ss]|[Yy]|)$ ]]; then
    MAKE_LINE
    echo "giting data"
    # runs the program with data>?  
    # MAKE_BACKUP_FILES
    UNINSTALL_Vinegar
    INSTALL_Vinegar
    RUN_Vinegar_FOR_SETUP
    # COPY_BACKUP_OVER
    echo "im done installing $FLATPAK_ID $USER"
else
    MAKE_LINE
    echo "no data / removing it"
    # runs the program no data
    if [ -d "$BACKUP_DIR" ]; then
    rm -rf $BACKUP_DIR/*
    else
    echo no file 4 $BACKUP_DIR
    fi
    UNINSTALL_Vinegar
    INSTALL_Vinegar
    RUN_Vinegar_FOR_SETUP
    echo "im done installing $FLATPAK_ID $USER"
fi

sleep 1
flatpak kill "$FLATPAK_ID" &>/dev/null || true
MAKE_LINE
sleep 1
konsole -e flatpak run $FLATPAK_ID 

sleep 10000