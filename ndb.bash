#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Uso: $0 <immagine.dd>"
    exit 1
fi

IMAGE="$1"   #disk image path as input

for inode in {15..39}; do
    #row after "Direct Blocks"
    direct_line=$(istat "$IMAGE" "$inode" | grep -A1 "Direct Blocks" | tail -n1)

    #if there are no direct blocks, print the inode number
    if ! echo "$direct_line" | grep -q "[0-9]"; then
        echo "Inode $inode: nessun Direct Block"
    fi
done