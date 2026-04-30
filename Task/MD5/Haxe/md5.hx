import haxe.crypto.Md5;

class Main {
  static function main() {	
    var md5 = Md5.encode("The quick brown fox jumped over the lazy dog's back");
    Sys.println(md5);
  }
}
