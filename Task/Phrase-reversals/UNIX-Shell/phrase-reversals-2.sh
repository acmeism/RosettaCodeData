s1="rosetta code phrase reversal"
echo "Original string                     --> "$s1

echo -n "1.) Reverse the string              --> "
length=$(echo $s1|wc -c)
while [ $length != 0 ];do
echo $s1|cut -c$length|tr -d "\n"
length=$(expr $length - 1)
done;echo

echo -n "2.) Reverse characters of each word --> "
word_quantity=$(echo $s1|wc -w)
word_quantity=$(expr $word_quantity + 1)
word_num=1
while [ $word_num != $word_quantity ];do
length=$(echo $s1|cut -d " " -f $word_num|wc -c)
while [ $length != 0 ];do
echo $s1|cut -d " " -f $word_num|cut -c$length|tr -d "\n"
length=$(expr $length - 1);done;echo -n " "
word_num=$(expr $word_num + 1);done;echo

echo -n "3.) Reverse word order              --> "
word_num=$(echo $s1|wc -w)
while [ $word_num != 0 ];do
echo -n $(echo $s1|cut -d " " -f $word_num);echo -n " "
word_num=$(expr $word_num - 1);done;echo
