import "io" for Stdin, Stdout
import "./pattern" for Pattern
import "./seq" for Lst

System.print("Please enter a multi-line story template terminated by a blank line:\n")
Stdout.flush()
var story = ""
while (true) {
    var line = Stdin.readLine()
    if (line.isEmpty) break
    story = story + line + "\n" // preserve line breaks
}
// identify blanks
var p = Pattern.new("<+0^>>")
var blanks = Lst.distinct(p.findAll(story).map { |m| m.text }.toList)
System.print("Please enter your replacements for the following 'blanks' in the story:")
for (blank in blanks) {
    System.write("  %(blank[1..-2]) : ")
    Stdout.flush()
    var repl = Stdin.readLine()
    story = story.replace(blank, repl)
}
System.print("\n%(story)")
