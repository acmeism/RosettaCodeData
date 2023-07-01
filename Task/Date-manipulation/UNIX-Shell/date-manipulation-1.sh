epoch=$(date -d 'March 7 2009 7:30pm EST +12 hours' +%s)
date -d @$epoch
TZ=Asia/Shanghai date -d @$epoch
