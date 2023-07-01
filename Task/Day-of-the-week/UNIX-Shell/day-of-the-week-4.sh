seq 2008 2121 | xargs -IYEAR -n 1 date +%c -d 'Dec 25 YEAR' | grep Sun
