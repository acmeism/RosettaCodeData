#! /bin/sh

LIMIT=1000

# As a workaround for missing arrays, we use variables p2, p3, ...,
# p$LIMIT, to represent the primes. Values are true or false.
#   eval p$i=true     # Set value.
#   eval \$p$i        # Run command: true or false.
#
# A previous version of this script created a temporary directory and
# used files named 2, 3, ..., $LIMIT to represent the primes. We now use
# variables so that a killed script does not leave extra files. About
# performance, variables are about as slow as files.

i=2
while [ $i -le $LIMIT ]
do
    eval p$i=true               # was touch $i
    i=`expr $i + 1`
done

i=2
while
    j=`expr $i '*' $i`
    [ $j -le $LIMIT ]
do
    if eval \$p$i               # was if [ -f $i ]
    then
        while [ $j -le $LIMIT ]
        do
            eval p$j=false      # was rm -f $j
            j=`expr $j + $i`
        done
    fi
    i=`expr $i + 1`
done

# was echo `ls|sort -n`
echo `i=2
      while [ $i -le $LIMIT ]; do
          eval \\$p$i && echo $i
          i=\`expr $i + 1\`
      done`
