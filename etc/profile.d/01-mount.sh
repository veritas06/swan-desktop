#!/bin/bash

[ -z "$MOUNT_FINISHED" ] || return

# bind windows user-dirs to home folder
if [ ! -e "$HOME/.config/user-dirs.dirs" ]; then
    if which xdg-user-dirs-update >/dev/null 2>&1; then
        xdg-user-dirs-update --force
    fi
fi

for d in DESKTOP DOCUMENTS DOWNLOAD MUSIC PICTURES PUBLICSHARE VIDEOS; do
	ud="$(xdg-user-dir $d)"
    mount | grep "\\s$ud\\s" >/dev/null && break
	upd="$(cygpath $USERPROFILE/$(basename $ud))"
    if [ ! "$(ls -A $ud)" ] && [ -e "$upd" ];  then
	mount -fo user $(cygpath -w $(readlink -f $upd)) $ud
	if [ ! -e "$ud/.hidden" ]; then
		echo 'desktop.ini' > "$ud/.hidden"
		attrib +H +S $(cygpath -w "$ud/.hidden")
	fi
    fi
done

export MOUNT_FINISHED=1
