coins(n) = for p in [200,100,50,20,10,5,2,1]
		       println("$(n÷p) coin(s) of $p")
		       n = n%p
	       end
