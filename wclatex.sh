#!/bin/sh
ARG=${1:-$PWD}

if [[ -d "$ARG" ]]; then
	# dir
	FILES=$(builtin cd $ARG && find . -name "*.tex" -type f)

elif [[ -f "$ARG" ]]; then
	# file
	FILES=$ARG
else
	echo Argument must be a file or directory!
	exit 1
fi

ROWS=$(for f in $FILES; do
	ABS=$(realpath $f)
	detex $ABS | wc -w
	wc -w $ABS | awk '{print $1}'
	echo $f
done | xargs -L3 echo | sort -h)

SEP="----- ----- \n"
TOTALS=$(echo  "$ROWS" | awk '{a+=$1;b+=$2}END{print a,b}')
echo -e "$ROWS\n$SEP $TOTALS Totals" | column -t -N "Detex'd,All Words,File"
