RESTOREUMASK=$(umask)
TRY=0
while :; do
   TRY=$(( TRY + 1 ))
   umask 0077
   MYTMP=${TMPDIR:-/tmp}/$(basename $0).$$.$(date +%s).$TRY
   trap "rm -fr $MYTMP" EXIT
   mkdir "$MYTMP" 2>/dev/null && break
done
umask "$RESTOREUMASK"
cd "$MYTMP" || {
   echo "Temporary directory failure on $MYTMP" >&2
   exit 1; }
