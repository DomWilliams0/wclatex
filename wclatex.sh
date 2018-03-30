#!/bin/sh
DIR=${1:-$PWD}
ROWS=$(for f in `(builtin cd $DIR && find . -name "*.tex" -type f)`; do
	ABS=$DIR/$f
	detex $ABS | wc -w
	wc -w $ABS | awk '{print $1}'
	echo $f
done | xargs -L3 echo | sort -h)

SEP="----- ----- \n"
TOTALS=$(echo  "$ROWS" | awk '{a+=$1;b+=$2}END{print a,b}')
echo -e "$ROWS\n$SEP $TOTALS Totals" | column -t -N "Detex'd,All Words,File"
