#!/usr/bin/env bash
DUMPFILE=$1
MAXHEAP="16g"

if [ -z ${2+x} ]; then
    echo "Max heap not set, using default $MAXHEAP";
else
    echo "Max heap is set to: $2";
    MAXHEAP=$2
fi

echo ${DUMPFILE}
/opt/mat/ParseHeapDump.sh ${DUMPFILE} org.eclipse.mat.api:suspects -vmargs -Xmx${MAXHEAP} -XX:-UseGCOverheadLimit
