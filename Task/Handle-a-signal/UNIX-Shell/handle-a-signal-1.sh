c="1"
# Trap signals for SIGQUIT (3), SIGABRT (6) and SIGTERM (15)
trap "echo -n 'We ran for ';echo -n `expr $c /2`; echo " seconds"; exit" 3 6 15
while [ "$c" -ne 0 ]; do    # infinite loop
  # wait 0.5    # We need a helper program for the half second interval
  c=`expr $c + 1`
done
