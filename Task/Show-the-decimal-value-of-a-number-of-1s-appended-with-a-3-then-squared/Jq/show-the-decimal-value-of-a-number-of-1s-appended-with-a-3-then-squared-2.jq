range(100; 106) as $n
| ((("1"*$n) + "3") | tonumber) as $number
| ($n|lpad(4)) + " "
 +  ($number|power(2)|tostring| gsub("123456790";"A") | gsub("987654320";"Z") | gsub("9876";"N") | lpad(40))
