#!/usr/bin/env bash
DUMPFILE=$1
MAXHEAP="16g"
SUSPECTS="org.eclipse.mat.api:suspects"
OVERVIEW="org.eclipse.mat.api:overview"
TOP_COMPONENTS="org.eclipse.mat.api:top_components"

if [ -z ${2+x} ]; then
    echo "Max heap not set, using default $MAXHEAP";
else
    echo "Max heap is set to: $2";
    MAXHEAP=$2
fi

if [ -z ${3+x} ]; then
    echo "No reports requested. Skipping generation";
else
    reports_for_command=""
    reports=$(echo $3 | tr "," " " | xargs)
    for report in $reports
    do
        if [ $report == 'suspects' ]; then
          reports_for_command="$reports_for_command $SUSPECTS"
        fi
        if [ $report == 'overview' ]; then
          reports_for_command="$reports_for_command $OVERVIEW"
        fi
        if [ $report == 'top_components' ]; then
          reports_for_command="$reports_for_command $TOP_COMPONENTS"
        fi
    done
fi

echo reports: ${reports_for_command}
/opt/mat/ParseHeapDump.sh ${DUMPFILE} $reports_for_command -vmargs -Xmx${MAXHEAP} -XX:-UseGCOverheadLimit
