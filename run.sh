#!/usr/bin/env bash
DUMPFILE=$1
MAXHEAP="16g"
SUSPECTS="org.eclipse.mat.api:suspects"

if [ -z ${2+x} ]; then
    echo "Max heap not set, using default $MAXHEAP";
else
    echo "Max heap is set to: $2";
    MAXHEAP=$2
fi

if [ -z ${3+x} ]; then
    echo "Skip suspects not set. Generating suspects report.";
else
    echo "Skipping suspects report";
    SUSPECTS=""
fi

echo ${DUMPFILE}
/opt/mat/ParseHeapDump.sh ${DUMPFILE} $SUSPECTS -vmargs -Xmx${MAXHEAP} -XX:-UseGCOverheadLimit
