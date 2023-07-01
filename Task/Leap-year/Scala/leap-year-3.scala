def isLeapYear(year:Int)=if (year%100==0) year%400==0 else year%4==0;

//or use Java's calendar class
def isLeapYear(year:Int):Boolean = {
  val c = new java.util.GregorianCalendar
  c.setGregorianChange(new java.util.Date(Long.MinValue))
  c.isLeapYear(year)
}
