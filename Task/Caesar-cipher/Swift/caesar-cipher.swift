func usage(_ e:String) {
  print("error: \(e)")
  print("./caeser -e 19 a-secret-string")
  print("./caeser -d 19 tskxvjxlskljafz")
}

func charIsValid(_ c:Character) -> Bool {
  return c.isASCII && ( c.isLowercase || 45 == c.asciiValue ) // '-' = 45
}

func charRotate(_ c:Character, _ by:Int) -> Character {
  var cv:UInt8! = c.asciiValue
  if 45 == cv { cv = 96 }  // if '-', set it to 'a'-1
  cv += UInt8(by)
  if 122 < cv { cv -= 27 } // if larget than 'z', reduce by 27
  if 96 == cv { cv = 45 }  // restore '-'
  return Character(UnicodeScalar(cv))
}

func caesar(_ enc:Bool, _ key:Int, _ word:String) -> String {
  let r = enc ? key : 27 - key
  func charRotateWithKey(_ c:Character) -> Character {
    return charRotate(c,r)
  }
  return String(word.map(charRotateWithKey))
}

func main() {
  var encrypt = true

  if 4 != CommandLine.arguments.count {
    return usage("caesar expects exactly three arguments")
  }

  switch ( CommandLine.arguments[1] ) {
  case "-e":
    encrypt = true
  case "-d":
    encrypt = false
  default:
    return usage("first argument must be -e (encrypt) or -d (decrypt)")
  }

  guard let key = Int(CommandLine.arguments[2]) else {
    return usage("second argument not a number (must be in range 0-26)")
  }

  if key < 0 || 26 < key {
    return usage("second argument not in range 0-26")
  }

  if !CommandLine.arguments[3].allSatisfy(charIsValid) {
    return usage("third argument must only be lowercase ascii characters, or -")
  }

  let ans = caesar(encrypt,key,CommandLine.arguments[3])
  print("\(ans)")
}

func test() {
  if ( Character("a") != charRotate(Character("a"),0) ) {
    print("Test Fail 1")
  }
  if ( Character("-") != charRotate(Character("-"),0) ) {
    print("Test Fail 2")
  }
  if ( Character("-") != charRotate(Character("z"),1) ) {
    print("Test Fail 3")
  }
  if ( Character("z") != charRotate(Character("-"),26)) {
    print("Test Fail 4")
  }
  if ( "ihgmkzma" != caesar(true,8,"a-zecret") ) {
    print("Test Fail 5")
  }
  if ( "a-zecret" != caesar(false,8,"ihgmkzma") ) {
    print("Test Fail 6")
  }
}

test()
main()
