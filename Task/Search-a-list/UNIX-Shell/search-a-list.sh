if [ $1 ];then
haystack="Zip Zag Wally Ronald Bush Krusty Charlie Bush Bozo"

index=$(echo $haystack|tr " " "\n"|grep -in "^$1$")
if [ $? = 0 ];then
quantity_of_hits=$(echo $index|tr " " "\n"|wc -l|tr -d " ")
first_index=$(echo $index|cut -f 1 -d ":")
if [ $quantity_of_hits = 1 ];then
echo The sole index for $1 is: $first_index
else
echo The smallest index for $1 is: $first_index
greatest_index=$(echo $index|tr " " "\n"|tail -1|cut -f 1 -d ":")
echo "The greatest index for $1 is: $greatest_index";fi
else echo $1 is absent from haystatck.;fi
else echo Must provide string to find in haystack.;fi
