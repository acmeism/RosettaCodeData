var n:Int=1000

func sum(x:Int)->Int{
	
	var s:Int=0
	for i in 0...x{
		if i%3==0 || i%5==0
		{
			s=s+i
		}
		
	}
	return s
}

var sumofmult:Int=sum(x:n)
print(sumofmult)
