import tools.threads, std.stdio, std.stream, std.thread;

void main() {
  // line or EOF
  struct InputLine {
    string data;
    bool eof;
    static InputLine opCall(string s) { InputLine res; res.data = s; return res; }
    static InputLine EOF() { InputLine res; res.eof = true; return res; }
  }
  auto LineCh = new MessageChannel!(InputLine),
    ResultCh = new MessageChannel!(int);
  auto printer = new Thread({
    int count;
    while (true) {
      auto line = LineCh.get();
      if (line.eof) break;
      count ++;
      writefln(count, ": ", line.data);
    }
    ResultCh.put(count);
    return 0;
  });
  printer.start;
  auto file = new File("input.txt");
  while (!file.eof()) {
    auto line = file.readLine();
    LineCh.put(InputLine(line));
  }
  LineCh.put(InputLine.EOF());
  writefln("Count: ", ResultCh.get());
}
