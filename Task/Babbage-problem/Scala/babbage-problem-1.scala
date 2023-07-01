object BabbageProblem {
    def main( args:Array[String] ): Unit = {
		
        var x : Int = 524        // Sqrt of 269696 = 519.something
		
        while( (x * x) % 1000000 != 269696 ){
            if( x % 10 == 4 ) x = x + 2
            else x = x + 8
        }
		
        println("The smallest positive integer whose square ends in 269696 = " + x )
    }
}
