import java.util.{GregorianCalendar, Calendar}

val DISCORDIAN_SEASONS=Array("Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath")
def ddate(year:Int, month:Int, day:Int):String={
   val date=new GregorianCalendar(year, month-1, day)
   val dyear=year+1166

   val isLeapYear=date.isLeapYear(year)
   if(isLeapYear && month==2 && day==29)
      return "St. Tib's Day "+dyear+" YOLD"

   var dayOfYear=date.get(Calendar.DAY_OF_YEAR)
   if(isLeapYear && dayOfYear>=60)
      dayOfYear-=1	// compensate for St. Tib's Day

   val dday=dayOfYear%73
   val season=dayOfYear/73
   "%s %d, %d YOLD".format(DISCORDIAN_SEASONS(season), dday, dyear)
}
