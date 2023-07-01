seed=675248
random(){
        seed=`expr $seed \* $seed / 1000 % 1000000`
        return seed
}
for ((i=1;i<=5;i++));
do
        random
        echo $?
done
