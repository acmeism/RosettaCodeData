cat csv | while read S; do
 [ -z ${S##*C*} ] && echo $S,SUM || echo $S,`echo $S | tr ',' '+' | bc`
done
