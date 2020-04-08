#!/bin/bash
set -Eeuxo pipefail

SIGNATURES=$1
TMPDIR=/tmp/falsisign-${RANDOM}
mkdir ${TMPDIR}
SIGNATURES_BN=$(basename "${SIGNATURES}" .pdf)

convert -density 576 -resize 3560x4752 -transparent white "${SIGNATURES}" "${TMPDIR}/${SIGNATURES_BN}.png"
file "${TMPDIR}/${SIGNATURES_BN}.png" | grep ' PNG image data, 3560 x 4752'  # We must have exactly the right resolution

mkdir -p signatures
for start_y in $(seq 0 528 4751)
do
    for start_x in 0 1058 2116
    do
        convert "${TMPDIR}/${SIGNATURES_BN}.png" -crop "1058x528+${start_x}+${start_y}" +repage \
                signatures/"${SIGNATURES_BN}_${start_x}x${start_y}".png
    done
done
