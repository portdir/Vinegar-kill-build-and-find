#!/bin/bash
# casts Vinegar stuff
cleanup(){
    echo -e "\n[STOPPING]"
    kill -- -$$ 2>/dev/null || true &
    trap - INT TERM
    exit 1
};
setupvars(){
# make files pointers and names
    echo -e"
    ----------------------------
    settingvars Vinegar for '$USER' in '$(tty)'"
    FlatVinegar=org.vinegarhq.Vinegar
    VinegarrootFile=~/.var/app/org.vinegarhq.Vinegar
    VinegarConf=~/.var/app/org.vinegarhq.Vinegar/config/vinegar/
    Vinegarflatpak=~/.local/share/flatpak/app/org.vinegarhq.Vinegar/
    Vinegarflatpakremove=~/.local/share/flatpak/.removed/org.vinegarhq.Vinegar-*
    # data
    RBXrootdir=~/.var
    backupRBX=$RBXrootdir/RBXbackup/data/vinegar
    TORSRS=$RBXrootdir/app/org.vinegarhq.Vinegar/data/vinegar/
    appdataRS=$TORSRS/appdata # RS appdata
    settingsRS=$TORSRS/settings.reg # RS settings
};

Vinegarremove(){
# uninstalls Vinegar
    echo "
    ----------------------------
    uninstalling Vinegar for  $USER"
    flatpak uninstall -y --delete-data $FlatVinegar
    flatpak uninstall -y --delete-data $FlatVinegar.Locale
    rm -rf $VinegarrootFile
    rm -rf $Vinegarflatpak
    rm -rf $Vinegarflatpakremove
};

Vinegaradd(){
# builds Vinegar
    echo "
    ----------------------------
    installing Vinegar for $USER"
    flatpak install --user -y flathub $FlatVinegar
    # config.toml
    mkdir -p $VinegarConf
    echo -e '
        debug = true
        [studio]
        channel = "LIVE"
        discord_rpc = false
        renderer = "Vulkan"
        webview = ""
        [studio.env]    
        PROTON_ENABLE_WAYLAND = "1"
    ' > $VinegarConf/config.toml
};

Vinegarrunforsetup(){
# runs Vinegar so i can kill it later with Prejudice
    konsole -e flatpak run $FlatVinegar & 
    local meow=$!
    sleep 2
    echo "$meow dont click on this Vinegar"
    kill -KILL $meow 2>/dev/null || true 
};

Vinegargrabdata(){
    # make sure that the file are there
    mkdir -p $backupRBX
    mkdir -p $RSRS
    mkdir -p $TORSRS
    # git the rbx data from your file
    mv -f $appdataRS $backupRBX/
    #cp -f $settingsRS $backupRBX/
};
Vinegaradddata(){
    #take from backup move back to RBXs
    cp -rf $backupRBX/* $TORSRS
};

Vinegarrun(){
    # runs Vinegar so i can kill it later with Prejudice
    flatpak run $FlatVinegar
};
echo -e "
    #-------------------
    # Vinegar sucks ass for one the gay guy. 
    # casts
    # v4.8.1
    ------------------
    Grab Vinegar/roblox data from last session? [Y/N] or hit enter
    #-------------------
"
read yesno
if [[ $yesno =~ ^(Y|y|yes|)$ ]]; then
        echo "giting data"
        # runs the program with data>?
        setupvars   
        Vinegargrabdata
        Vinegarremove
        Vinegaradd
        Vinegarrunforsetup 
        Vinegaradddata
        echo "im done installing $FlatVinegar $USER"
    else
        echo "no data"
        # runs the program no data
        rm -rf $backupRBX/*
        setupvars
        Vinegarremove
        Vinegaradd
        Vinegarrunforsetup
        echo "im done installing $FlatVinegar $USER"

fi
sleep 1
pkill -f vinegar
Vinegarrun
exit 1
