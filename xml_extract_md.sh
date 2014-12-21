#!/bin/sh

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
    local RET=$?
    TAG_NAME=${ENTITY%% *}
    ATTRIBUTES=${ENTITY#* }
    return $RET
}

# | sed 's#^#${UDSRC}/#' | cat

while read_dom; do
    if [[ $ENTITY = "string" ]] ; then
	if [[ "$CONTENT" == *ulysses ]] ; then
		cat "${1}/$CONTENT/Text.txt" | sed '/^%%/ d'
	fi
    fi
done < $1"/Info.ulgroup"
