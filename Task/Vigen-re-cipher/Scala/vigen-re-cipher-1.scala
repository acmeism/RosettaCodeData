import scala.language.implicitConversions

//
// Translate Special Chars to Names
// --------------------------------
//
class VText

class KeyText( key:String ) extends VText {
  override def toString = key
}

object KeyText {
  def apply(k:String) = new KeyText( "[^A-Z]*".r.replaceAllIn(k.toUpperCase,"") )
}


class PlainText( message:String ) extends VText {
  override def toString = {
    "[^A-Z]*".r.replaceAllIn(message.toUpperCase,"")
    .replaceAll("FULLSTOP",".")
    .replaceAll("CERO","0")
    .replaceAll("EINZ","1")
    .replaceAll("ZWEI","2")
    .replaceAll("TRES","3")
    .replaceAll("CUATRO","4")
    .replaceAll("CINQ","5")
    .replaceAll("SECHS","6")
    .replaceAll("SIETE","7")
    .replaceAll("HUIT","8")
    .replaceAll("NEUF","9")
  }

  def toRawString = message
}

object PlainText {
  def apply(k:String) = new PlainText( k.toList.map(_.toString).map {
    case "0" => "CERO"
    case "1" => "EINZ"
    case "2" => "ZWEI"
    case "3" => "TRES"
    case "4" => "CUATRO"
    case "5" => "CINQ"
    case "6" => "SECHS"
    case "7" => "SIETE"
    case "8" => "HUIT"
    case "9" => "NEUF"
    case "." => "FULLSTOP"
    case a:String => "[^A-Z]*".r.replaceAllIn(a.toUpperCase,"")
  }.mkString )
}


class CipherText( cipher:String ) extends VText {
  override def toString = cipher
}

object CipherText {
  def apply(k:String) = new CipherText(
    "[^A-Z]*".r.replaceAllIn(k.toUpperCase,"")
  )
}


//
// The Vigenère Cipher
// -------------------
//
def vcipher( key:KeyText )( plaintext:PlainText ) : CipherText = {
  val k = key.toString
  val p = plaintext.toRawString
  val kp = (k * (p.length / k.length + 1)) zip (p)

  CipherText( (for( t <- kp; k = (t._1 - 'A'); p = (t._2 - 'A'); a = 'A' + (p + k) % 26 ) yield (a.toChar)).mkString )
}

def vdecipher( key:KeyText )( ciphertext:CipherText ) : PlainText = {
  val k = key.toString
  val c = ciphertext.toString
  val kc = (k * (c.length / k.length + 1)) zip (c)

  PlainText( (for( t <- kc; k = (t._1 - 'A'); c = (t._2 - 'A'); a = 'A' + (26 + c - k) % 26 ) yield (a.toChar)).mkString )
}


// Use Implicits to overcome the ambiguity problem of overloaded partial functions
implicit def VTextToString( v:VText ) : String = v match {
  case k:KeyText => k.toString
  case p:PlainText => p.toString
  case c:CipherText => c.toString
  case _ => ""
}
implicit def StringToKeyText( s:String ) = KeyText(s)
implicit def StringToPlainText( s:String ) = PlainText(s)
implicit def StringToCipherText( s:String ) = CipherText(s)



// Validate cipher/decipher
assert( vcipher("LEMON")("ATTACKATDAWN").toString == "LXFOPVEFRNHR" )
assert( vdecipher("LEMON")("LXFOPVEFRNHR").toString == "ATTACKATDAWN" )


// A quick test
val todaysKey = "lemon"
val todaysCipher = vcipher(todaysKey) _
val todaysDecipher = vdecipher(todaysKey) _

val plaintext = "Attack at 0620."
val ciphertext = todaysCipher(plaintext)

println( "   Message:  " + plaintext + "\n" )
println( "Enciphered:  " + ciphertext + "\n" )
println( "Deciphered:  " + todaysDecipher( ciphertext ) + "\n" )
