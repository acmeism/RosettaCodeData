$$ MODE TUSCRIPT,{}
input="WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW",output=""
string=strings(input," ? ")
letter=ACCUMULATE(string,freq)
freq=SPLIT(freq),letter=SPLIT(letter)
output=JOIN(freq,"",letter)
output=JOIN(output,"")
PRINT input
PRINT output
