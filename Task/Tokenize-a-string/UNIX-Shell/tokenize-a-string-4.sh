string1="Hello,How,Are,You,Today"
elements_quantity=$(echo $string1|tr "," "\n"|wc -l)

present_element=1
while [ $present_element -le $elements_quantity ];do
echo $string1|cut -d "," -f $present_element|tr -d "\n"
if [ $present_element -lt $elements_quantity ];then echo -n ".";fi
present_element=$(expr $present_element + 1)
done
echo

# or to cheat
echo "Hello,How,Are,You,Today"|tr "," "."
