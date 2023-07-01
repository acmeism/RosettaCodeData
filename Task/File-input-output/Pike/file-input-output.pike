object lines = Stdio.File("input.txt")->line_iterator();
object out = Stdio.File("output.txt", "cw");
foreach(lines; int line_number; string line)
    out->write(line + "\n");
