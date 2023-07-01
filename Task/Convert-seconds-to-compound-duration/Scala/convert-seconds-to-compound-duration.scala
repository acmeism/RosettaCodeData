//Converting Seconds to Compound Duration

object seconds{
	def main( args:Array[String] ){
		
		println("Enter the no.")
		val input = scala.io.StdIn.readInt()
		
		var week_r:Int = input % 604800
		var week:Int = (input - week_r)/604800
		
		var day_r:Int = week_r % 86400
		var day:Int = (week_r - day_r)/86400
		
		var hour_r:Int = day_r % 3600
		var hour:Int = (day_r - hour_r)/3600
		
		var minute_r:Int = hour_r % 60
		var minute:Int = (hour_r - minute_r)/60
		
		var sec:Int = minute_r % 60
		
		println("Week = " + week)
		println("Day = " + day)
		println("Hour = " + hour)
		println("Minute = " + minute)
		println("Second = " + sec)
	}
}
