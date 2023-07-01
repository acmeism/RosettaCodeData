object makepwd extends App {

  def newPassword( salt:String = "", length:Int = 13, strong:Boolean = true ) = {

    val saltHash = salt.hashCode & ~(1 << 31)

    import java.util.Calendar._

    val cal = java.util.Calendar.getInstance()
    val rand = new scala.util.Random((cal.getTimeInMillis+saltHash).toLong)
    val lower = ('a' to 'z').mkString
    val upper = ('A' to 'Z').mkString
    val nums = ('0' to '9').mkString
    val strongs = "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~"
    val unwanted = if( strong ) "" else "0Ol"

    val pool = (lower + upper + nums + (if( strong ) strongs else "")).
               filterNot( c => unwanted.contains(c) )

    val pwdStream = Stream.continually( (for( n <- 1 to length; c = pool(rand.nextInt(pool.length) ) ) yield c).mkString )

    // Drop passwords that don't have at least one of each required character
    pwdStream.filter( pwd =>
      pwd.exists(_.isUpper) &&
      pwd.exists(_.isLower) &&
      pwd.exists(_.isDigit) &&
      (if(strong) pwd.exists(! _.isLetterOrDigit) else true)
    ).head
  }

  val pwdLength = """^(\d{1,4})$""".r
  val howMany = """^\-n(\d{0,3})$""".r
  val help = """^\-\-(help)$""".r
  val pwdSalt = """^\-s(.*)""".r
  val strongOption = """(?i)(strong)""".r


  var (salt,length,strong,helpWanted,count,unknown) = ("",13,false,false,1,false)

  args.foreach{
    case pwdLength(l) =>    length = math.min(math.max(l.toInt,6),4000)
    case strongOption(s) => strong = true
    case pwdSalt(s) =>      salt = s
    case howMany(c) =>      count = math.min(c.toInt,100)
    case help(h) =>         helpWanted = true
    case _ =>               unknown = true
  }

  if( count > 1 ) println

  if( helpWanted || unknown ) {
    println( """
  makepwd <length> "strong" -s<salt> -n<how-many> --help

    <length>     = how long should the password be
    "strong"     = strong password, omit if special characters not wanted
    -s<salt>     = "-s" followed by any non-blank characters
                     (increases password randomness)
    -n<how-many> = "-n" followed by the number of passwords wanted
    --help       = displays this

  For example: makepwd 13 strong -n20 -sABCDEFG
""".stripMargin )
  }
  else for( i <- 1 to count ) println( newPassword( i + salt, length, strong ) )

  if( count > 1 ) println
}
