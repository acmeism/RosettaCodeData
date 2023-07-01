#! /bin/bash
program="1/1 455/33 11/13 1/11 3/7 11/2 1/3"
echo $program | tr " " "\n" | cut -d"/" -f1 | tr "\n" " " > "data"
read -a ns < "data"
echo $program | tr " " "\n" | cut -d"/" -f2 | tr "\n" " " > "data"
read -a ds < "data"


t=0
n=72
echo "steps of computation" > steps.csv
while [ $t -le 6 ]; do
	if [ $(($n*${ns[$t]}%${ds[$t]})) -eq 0 ]; then
		let "n=$(($n*${ns[$t]}/${ds[$t]}))"
		let "t=0"
		factor $n >> steps.csv
	fi
	let "t=$t+1"
done
