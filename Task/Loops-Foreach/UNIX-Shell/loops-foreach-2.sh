PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:/usr/local/bin

oldifs=$IFS
IFS=:
for dir in $PATH; do
  echo search $dir
done
IFS=$oldifs
