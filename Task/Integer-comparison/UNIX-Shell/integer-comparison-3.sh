read -p "Enter two integers: " a b

if [ $a -gt $b ]; then comparison="greater than"
elif [ $a -lt $b ]; then comparison="less than"
elif [ $a -eq $b ]; then comparison="equal to"
else comparison="not comparable to"
fi

echo "${a} is ${comparison} ${b}"
