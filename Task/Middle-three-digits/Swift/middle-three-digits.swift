var num:Int = \\enter your number here
if num<0{num = -num}
var numArray:[Int]=[]
while num>0{
	var temp:Int=num%10
	numArray.append(temp)
	num=num/10
}
var i:Int=numArray.count
if i<3||i%2==0{
	print("Invalid Input")
}
else{
	i=i/2
	print("\(numArray[i+1]),\(numArray[i]),\(numArray[i-1])")
}
