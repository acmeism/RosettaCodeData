using ZLib.Utility;

void main() {
  var str = (uint8[])"The quick brown fox jumps over the lazy dog".to_utf8();
  stdout.printf("%lx\n", crc32(0, str));
}
