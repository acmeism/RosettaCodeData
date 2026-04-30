import haxe.crypto.Sha1;

class Main {
  static function main() {
    var sha1 = Sha1.encode("Rosetta Code");
    Sys.println(sha1);
  }
}
