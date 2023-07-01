#! /bin/bash
# Carter's calendar algorithm: https://web.archive.org/web/19990117015544/http://www.ast.cam.ac.uk/pubinfo/leaflets/easter/easter.html
set -e

easter() {
	(( year=$1 ))

	if [[ year -gt 2099 ]]
	then
		echo "Error year  This algorithm does not work after 2099."
		exit 1
	fi

	(( day = 225 - 11 * (year % 19) ))

	while (( day > 50 ))
	do
		(( day -= 30 ))
	done

	if (( day > 48 ))
	then
		(( --day ))
	fi

	(( day = day + 7 - (year + year/4 + day + 1) % 7 ))

	echo $day
}

for year in {1998..2100}
do
	(( day=$( easter $year ) ))
	if (( day < 32 ))
	then
		printf "%d-%02d-%02d\n" $year 3 $day
	else
		(( day -= 31 ))
		printf "%d-%02d-%02d\n" $year 4 $day
	fi
done
