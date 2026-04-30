using StringTools;

class Main {
  static function main() {
    var data = haxe.io.Bytes.ofString("The quick brown fox jumps over the lazy dog");
    var crc = haxe.crypto.Crc32.make(data);
    Sys.println(crc.hex());
  }
}
