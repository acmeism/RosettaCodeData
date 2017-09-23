//Multiplication Table

object mulTable{
	def main( args:Array[String] ){
		
		print("    |")			//Horizontal row
		for( i <- 1 to 12 )
			if( i<10 )
				print( "    " + i )
			else
				print("   " + i )
		println("")
		println("---------------------------------------------------------------------")
		
		for( i <- 1 to 12 ){
			
			if( i<10 )						//Vertical column
				print("   " + i + "|" )
			else
				print("  " + i + "|" )
			
			
			for( j <- 1 to 12 ){
				
				if( i*j < 10 ){
					if( i<=j )
						print("    " + i*j )
					else
						print("     ")
				}
				else if( i*j < 100 ){
					if( i<=j )
						print("   " + i*j )
					else
						print("     ")
				}
				else{
					if( i<=j )
						print("  " + i*j )
					else
						print("     ")
				}
			}
			println("")
		}
		
	}
}
