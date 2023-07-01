//
// A Unicode test string
//
val ulist = 0x8232.toChar :: 0xFFF9.toChar :: 0x200E.toChar :: (1.toChar to 2000.toChar).toList
val ustring = scala.util.Random.shuffle( ulist ).mkString

// Remove control codes including private codes
val sNoCtrlCode = ustring.replaceAll("[\\p{C}]","")

val htmlNoCtrlCode = for( i <- sNoCtrlCode.indices ) yield
  "&#" + sNoCtrlCode(i).toInt + ";" + (if( (i+1) % 10 == 0 ) "\n" else "")
println( "ctrl filtered out: <br/><br/>\n\n" + htmlNoCtrlCode.mkString  + "<br/><br/>\n" )


// Keep 0x00-0x7f and remove control codes
val sNoExtCode = ustring.replaceAll("[^\\p{InBasicLatin}]","").replaceAll("[\\p{C}]","")

val htmlNoExtCode = for( i <- sNoExtCode.indices ) yield
  "&#" + sNoExtCode(i).toInt + ";" + (if( (i+1) % 10 == 0 ) "\n" else "")
println( "ctrl and extended filtered out: <br/><br/>\n\n" + htmlNoExtCode.mkString  + "<br/><br/>\n" )
