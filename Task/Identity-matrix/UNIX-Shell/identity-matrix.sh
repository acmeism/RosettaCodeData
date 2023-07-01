for i in `seq $1`;do printf '%*s\n' $1|tr ' ' '0'|sed "s/0/1/$i";done
