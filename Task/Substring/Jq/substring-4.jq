$ jq -M -n -r -f Substring.jq
s[1:2] => 二
s[9:] => 十
s|.[0:length-1] => 一二三四五六七八九
s | ix("五") as $i | .[$i: $i + 1] => 五
s | ix("五六") as $i | .[$i: $i + 2] => 五六
