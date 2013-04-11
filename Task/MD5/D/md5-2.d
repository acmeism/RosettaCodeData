import tango.io.digest.Md5, tango.io.Stdout;

void main(char[][] args) {
  auto md5 = new Md5();
  for(int i = 1; i < args.length; i++) {
    md5.update(args[i]);
    Stdout.formatln("[{}]=>\n[{}]", args[i], md5.hexDigest());
  }
}
