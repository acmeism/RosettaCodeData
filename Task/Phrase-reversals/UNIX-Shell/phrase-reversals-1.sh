s1="rosetta code phrase reversal"
echo "Original string ----------------------> "$s1

echo -n "1.) Reverse the string ---------------> "
echo $s1|rev

echo -n "2.) Reverse characters of each word --> "
echo $s1|tr " " "\n"|rev|tr "\n" " ";echo

echo -n "3.) Reverse word order ---------------> "
word_num=$(echo $s1|wc -w)
while [ $word_num != 0 ];do
echo -n $(echo $s1|cut -d " " -f $word_num);echo -n " "
word_num=$(expr $word_num - 1);done;echo
