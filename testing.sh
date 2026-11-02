#!/bin/bash

##############################################################
# about
testine="0"
MADE_BY="Casts" # 
PRO_VERSION="v9.1.1" # 
PRO_ABOUT="# notes
\n# this makes a copy of your roblox cookies in your home dir called .RBX_Backup,
\n# ---> dont give that out. <---
\n#
\n# theres a config.toml change that to change your Vinegar settings.
\n#
\n# and theres a file log.log in the dir for testing.
\n# Note so self TEST_FUN_DEL_ALL is in safe." # notes 
##############################################################
# data
FLATPAK_ID="org.vinegarhq.Vinegar" # the FLATPAK install name
VINEGAR_DIR="$HOME/.var/app/$FLATPAK_ID" # where its installed
BACKUP_DIR="$HOME/.RBX_Backup" # backups go's here
DATA_TARGET="$VINEGAR_DIR/data/vinegar" # where to get the data for the backup
##############################################################
cleanup(){
    echo -e "$(date --rfc-3339 ns) [CHECK_fun] cleanup " >> log.log
    echo -e "\n[STOPPING]\n"
    flatpak kill "$FLATPAK_ID" &>/dev/null || true
    kill -- -$$ 2>/dev/null || true &
    trap - INT TERM
    exit 1
};
trap cleanup INT TERM

MAKE_LINE(){
    printf %"$COLUMNS"s|tr " " "-"
};

DUBBLE_CHECK(){
    echo -e "[STARTED] $(date --rfc-3339 ns)" >> log.log
    echo "[CHECK] $FLATPAK_ID" >> log.log
    echo "[CHECK] $MADE_BY" >> log.log
    echo "[CHECK] $PRO_VERSION" >> log.log
    MAKE_LINE
    #-----------------------
    echo -e "loking for $VINEGAR_DIR "
    [[ ! -d "$VINEGAR_DIR" ]] && 
    echo -e "NO file VINEGAR_DIR $VINEGAR_DIR " &&
    echo -e "[CHECK] NO file VINEGAR_DIR $VINEGAR_DIR" >> log.log
    echo -e "\n"
    [[ -d "$VINEGAR_DIR" ]] && 
    echo -e "[CHECK] THERE is file DATA_TARGET $VINEGAR_DIR" >> log.log 
    MAKE_LINE
    #-----------------------
    echo -e "loking for $BACKUP_DIR"
    [[ ! -d "$BACKUP_DIR" ]] && 
    echo -e "NO file BACKUP_DIR $BACKUP_DIR" &&
    echo -e "[CHECK] NO file BACKUP_DIR $BACKUP_DIR" >> log.log
    echo -e "\n"
    [[ -d "$BACKUP_DIR" ]] && 
    echo -e "[CHECK] THERE is file DATA_TARGET $BACKUP_DIR" >> log.log 
    MAKE_LINE
    #-----------------------
    echo -e "loking for $DATA_TARGET"
    [[ ! -d "$DATA_TARGET" ]] && 
    echo -e "NO file DATA_TARGET $DATA_TARGET" &&
    echo -e "[CHECK] NO file DATA_TARGET $DATA_TARGET" >> log.log 
    echo -e "\n"
    [[ -d "$DATA_TARGET" ]] && 
    echo -e "[CHECK] THERE is file DATA_TARGET $DATA_TARGET" >> log.log 
    MAKE_LINE
    echo -e "DONE checking dir's"
    echo -e "$(date --rfc-3339 ns) [CHECK] DONE checking dir's" >> log.log 
};

TEST_FUN_DEL_ALL(){
    flatpak kill "$FLATPAK_ID" &>/dev/null || true
    flatpak uninstall -y --delete-data --force-remove $FLATPAK_ID
    flatpak uninstall -y --delete-data --force-remove $FLATPAK_ID.Locale
    [[ -d "$VINEGAR_DIR" ]] && rm -rf "${VINEGAR_DIR:?}" 2>&1 | tee -a testlog.log
    [[ -d "$BACKUP_DIR" ]] && rm -rf "${BACKUP_DIR:?}" 2>&1 | tee -a log.log
    cleanup
};

UNINSTALL_Vinegar(){
    echo -e "$(date --rfc-3339 ns) [CHECK_fun] UNINSTALL_Vinegar " >> log.log
    # uninstalls Vinegar
    MAKE_LINE
    flatpak kill "$FLATPAK_ID" &>/dev/null || true
    flatpak uninstall -y --delete-data --force-remove $FLATPAK_ID
    flatpak uninstall -y --delete-data --force-remove $FLATPAK_ID.Locale
    echo -e "^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ 
    NO $FLATPAK_ID.Locale is okay keep going"
    [[ -d "$VINEGAR_DIR" ]] && rm -rf "${VINEGAR_DIR:?}" 2>&1 | tee -a testlog.log
};

INSTALL_Vinegar(){
    echo -e "$(date --rfc-3339 ns) [CHECK_fun] INSTALL_Vinegar " >> log.log
    # builds Vinegar
    MAKE_LINE
    echo -e "installing $FLATPAK_ID for $USER\n"
    flatpak install -y --system flathub "$FLATPAK_ID"
    MAKE_LINE
    echo -e "making config.toml for $USER\n"
    # config.toml
    [[ -f "$VINEGAR_DIR/config/vinegar/config.toml" ]] && 
    echo -e "[ERROR] file config.toml is still there this is bad!" >> log.log 
    [[ ! -f "$VINEGAR_DIR/config/vinegar/config.toml" ]] &&
    mkdir -p "$VINEGAR_DIR/config/vinegar" 2>&1 | tee -a log.log &&
    touch "$VINEGAR_DIR/config/vinegar/config.toml" 2>&1 | tee -a log.log &&
    [[ -f "$PWD/config.toml" ]] && cp --force "$PWD/config.toml" "$VINEGAR_DIR/config/vinegar/config.toml" 2>&1 | tee -a log.log
};

RUN_Vinegar_FOR_SETUP(){
    echo -e "$(date --rfc-3339 ns) [CHECK_fun] RUN_Vinegar_FOR_SETUP " >> log.log
    # runs Vinegar so i can kill it later with Prejudice
    konsole -e flatpak run $FLATPAK_ID &

    while true; do
        if [ -d "$VINEGAR_DIR" ]; then
            [ -d "$VINEGAR_DIR" ] && echo "[CHECK] $VINEGAR_DIR MADE" 2>&1 | tee -a log.log
            sleep 1
            flatpak kill "$FLATPAK_ID" &>/dev/null || true
            break
        fi
            sleep 2
            echo "still here"
    done
};

MAKE_BACKUP_FILES(){
    local VINEGAR_PID=$(pgrep -f "/home/$USER/.var/app/org.vinegarhq.Vinegar/data/vinegar/versions")

    if [ -n "$VINEGAR_PID" ]; then
        kill "$VINEGAR_PID" 
        testine=$(($testine + 1)) && echo -e "$(date --rfc-3339 ns) [CHECK_TEST_remove] made it to killing a VINEGAR pid of $VINEGAR_PID ? $testine " >> log.log
    fi
    local log_files=("$VINEGAR_DIR"/cache/vinegar/logs/*) 
    local meow=$(grep -q 'DBG Backed up Studio Registry' $VINEGAR_DIR/cache/vinegar/logs/"$(ls -1rt $VINEGAR_DIR/cache/vinegar/logs/| tail -n1 )" ) 

    if [ -f "${log_files[0]}" ]; then
        testine=$(($testine + 1)) && echo -e "$(date --rfc-3339 ns) [CHECK_TEST_remove] made it to there are logs? $testine " >> log.log
        while true; do
            if $meow; then
                flatpak kill "$FLATPAK_ID" &>/dev/null || true
                echo -e "$(date --rfc-3339 ns) [CHECK_fun] MAKE_BACKUP_FILES " >> log.log
                # make sure that the file are there
                [[ -d "$BACKUP_DIR" ]] && rm -rf "${BACKUP_DIR:?}" 2>&1 | tee -a log.log
                [[ ! -d "$BACKUP_DIR" ]] && mkdir -p "$BACKUP_DIR/data/vinegar/" 2>&1 | tee -a log.log
                # git the rbx appdata from your file
                sleep 1
                testine=$(($testine + 1)) && echo -e "$(date --rfc-3339 ns) [CHECK_TEST_remove] made it to copying backups? $testine " >> log.log
                #[[ -d "$DATA_TARGET/appdata" ]] && cp -r --force "$DATA_TARGET"/appdata "$BACKUP_DIR"/data/vinegar/appdata 2>&1 | tee -a log.log
                # ^^ need some more testing?
                [[ -f "$DATA_TARGET/settings.reg" ]] && cp --force "$DATA_TARGET"/settings.reg "$BACKUP_DIR"/data/vinegar/settings.reg 2>&1 | tee -a log.log
                break
            fi
                sleep 2
        done
    fi
};

COPY_BACKUP_TO_Vinegar(){
    echo -e "$(date --rfc-3339 ns) [CHECK_fun] COPY_BACKUP_TO_Vinegar" >> log.log
    #take from backup move back to RBXs
    [[ -d "$DATA_TARGET" ]] && rm -rf "${DATA_TARGET:?}" 2>&1 | tee -a log.log
    [[ ! -d "$DATA_TARGET" ]] && mkdir -p "$DATA_TARGET/data/vinegar/" 2>&1 | tee -a log.log
    sleep 1
    [[ -d "$BACKUP_DIR" && -d "$DATA_TARGET" ]] && cp -rf "${BACKUP_DIR:?}"/data/vinegar/. "$DATA_TARGET" 2>&1 | tee -a log.log
};

RUNINGask(){
    echo -e "$(date --rfc-3339 ns) [CHECK_fun] RUNINGask " >> log.log
echo -e "
$(MAKE_LINE)
# "$FLATPAK_ID" sucks ass for one the gay guy. 
# BY: "$MADE_BY"
# Version: "$PRO_VERSION"
"$PRO_ABOUT"
$(MAKE_LINE)
# yes = Make "BACKUP_DIR" , moves a copy of BACKUP_DIR to vinegar
# no = deletes "BACKUP_DIR" , no data copy
#
# Grab Vinegar/roblox data from last session? [Y/N] or hit enter for yes
$(MAKE_LINE)
"
    read -p "[Y/N]-->" yesno
    if [[ $yesno =~ ^([Yy][Ee][Ss]|[Yy]|)$ ]]; then
        MAKE_LINE
        echo -e "\nMoveing Data" 
        # runs the program with data ? 
        echo "MAKE_BACKUP_FILES"

        MAKE_BACKUP_FILES
        MAKE_LINE
        echo "UNINSTALL_Vinegar"

        sleep 1
        UNINSTALL_Vinegar
        MAKE_LINE
        echo "INSTALL_Vinegar"

        INSTALL_Vinegar
        MAKE_LINE
        echo "RUN_Vinegar_FOR_SETUP"

        RUN_Vinegar_FOR_SETUP
        MAKE_LINE
        echo "COPY_BACKUP_TO_Vinegar"

        COPY_BACKUP_TO_Vinegar
    else
        
        MAKE_LINE
        echo "No Data / Removing BACKUP"
        # runs the program no data

        [[ -d "$BACKUP_DIR" ]] && rm -rf "${BACKUP_DIR:?}" 2>&1 | tee -a log.log
        echo "UNINSTALL_Vinegar"
        UNINSTALL_Vinegar
        MAKE_LINE
        echo "INSTALL_Vinegar"
        INSTALL_Vinegar
        MAKE_LINE
        echo "RUN_Vinegar_FOR_SETUP"
        RUN_Vinegar_FOR_SETUP
    fi
    echo -e "$(date --rfc-3339 ns) [CHECK] im done installing $FLATPAK_ID for $USER" 2>&1 | tee -a log.log

    MAKE_LINE
};
# TEST_FUN_DEL_ALL
DUBBLE_CHECK
RUNINGask
trap - INT TERM 
exit 1
# OLD code
# testine=$(($testine + 1)) && echo -e "$(date --rfc-3339 ns) [CHECK_TEST_remove] made it? $testine " >> testlog.log

