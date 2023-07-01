is_palyndrom_date() { date -d "$1" 1>/dev/null 2>&1 && echo "$1" ; }

for _H in {2..9}; do
 for _I in {0..9}; do
  for _J in {0..99}; do
   is_palyndrom_date ${_H}${_I}`printf "%02d%s" ${_J}`-`printf "%02d%s" ${_J} | rev`-`printf "%02d%s" ${_H}${_I} | rev`
  done
 done
done
