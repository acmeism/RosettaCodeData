OneList=["zero",    "one",     "two",       "three",    "four",
              "five",    "six",     "seven",     "eight",    "nine",
              "ten",     "eleven",  "twelve",    "thirteen", "fourteen",
              "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
tenList=["" , "" , "twenty",  "thirty", "fourty",
            "fifty", "sixty", "seventy", "eighty", "ninety"]

millionStr="Million"
thousandStr="Thousand"
hundredStr="Hundred"
andStr="And"
pointStr=" Point "

while true
	see "enter number to convert:"
	give theNumber
	
	pointSplited=splitString(theNumber,".")
	fraction=0

	useFr=false
	if len(pointSplited) >=1 theNumber=pointSplited[1] ok
	if len(pointSplited) >=2 useFr=true fraction=pointSplited[2] ok
	pointSplited=null

	see getName(number(theNumber))
	if useFr=true see pointStr + getName(number(fraction)) ok
	see nl
end

func getName num
rtn=null
if num=0
    rtn += OneList[floor(num+1)]
	return rtn
ok
if num<0
	return "minus " + getName(fabs(num))
ok
if num>= 1000000
	rtn += getName(num / 1000000) +" "+ millionStr
	num%=1000000
ok
if num>=1000
	if len(rtn)>0 rtn += ", " ok

	rtn += getName(num / 1000)+ " " + thousandStr
	num%=1000
ok

if num >=100
if len(rtn)>0 rtn += ", " ok
	rtn += OneList[floor((num / 100)+1)] + " " + hundredStr
	num%=100
ok

if num=0
	return rtn +
ok
if len(rtn)>0 rtn += " " + andStr + " " ok
if(num>=20)

	rtn += tenList[floor((num / 10)+1)]
	num%=10
ok
if num=0
	return rtn
ok
if len(rtn)>0 rtn +=  " " ok
rtn += OneList[num+1]
return rtn

func splitString str,chr
	for i in str if strcmp(i,chr)=0 i=nl ok next
	return str2list(str)
