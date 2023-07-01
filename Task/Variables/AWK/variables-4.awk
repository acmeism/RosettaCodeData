# Feeding standard-input with echo:
echo -e "2 apples 0.44$ \n 3 banana 0.33$" | awk '{p=$1*$NF; sum+=p; print $2,":",p; }; END{print "Sum=",sum}'
