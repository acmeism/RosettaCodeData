//Pascal Matrix Generator

object pascal{
	def main( args:Array[String] ){
		
		println("Enter the order of matrix")
		val n = scala.io.StdIn.readInt()
		
		var F = new Factorial()
		
		var mx = Array.ofDim[Int](n,n)
		
		for( i <- 0 to (n-1); j <- 0 to (n-1) ){
			
			if( i>=j ){			//iCj
				mx(i)(j) = F.fact(i) / ( ( F.fact(j) )*( F.fact(i-j) ) )
			}
		}
		
		println("iCj:")
		for( i <- 0 to (n-1) ){		//iCj print
			for( j <- 0 to (n-1) ){
				print( mx(i)(j)+" " )
			}
			println("")
		}
		
		println("jCi:")
		for( i <- 0 to (n-1) ){		//jCi print
			for( j <- 0 to (n-1) ){
				print( mx(j)(i)+" " )
			}
			println("")
		}
		
		//(i+j)C j
		for( i <- 0 to (n-1); j <- 0 to (n-1) ){
			
			mx(i)(j) = F.fact(i+j) / ( ( F.fact(j) )*( F.fact(i) ) )
		}
		//print (i+j)Cj
		println("(i+j)Cj:")
		for( i <- 0 to (n-1) ){
			for( j <- 0 to (n-1) ){
				print( mx(i)(j)+" " )
			}
			println("")
		}
		
	}
}

class Factorial(){
	
	def fact( a:Int ): Int = {
		
		var b:Int = 1
		
		for( i <- 2 to a ){
			b = b*i
		}
		return b
	}
}
