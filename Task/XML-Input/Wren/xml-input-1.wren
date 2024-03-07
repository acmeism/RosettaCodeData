import "./pattern" for Pattern
import "./fmt" for Conv

var xml =
"<Students>
  <Student Name=\"April\" Gender=\"F\" DateOfBirth=\"1989-01-02\" />
  <Student Name=\"Bob\" Gender=\"M\"  DateOfBirth=\"1990-03-04\" />
  <Student Name=\"Chad\" Gender=\"M\"  DateOfBirth=\"1991-05-06\" />
  <Student Name=\"Dave\" Gender=\"M\"  DateOfBirth=\"1992-07-08\">
    <Pet Type=\"dog\" Name=\"Rover\" />
  </Student>
  <Student DateOfBirth=\"1993-09-10\" Gender=\"F\" Name=\"&#x00C9;mily\" />
</Students>"

var p = Pattern.new("<+1^>>")
var p2 = Pattern.new(" Name/=\"[+1^\"]\"")
var p3 = Pattern.new("/&/#x[+1/h];")
var matches = p.findAll(xml)
for (m in matches) {
    var text = m.text
    if (text.startsWith("<Student ")) {
        var match = p2.find(m.text)
        if (match) {
            var name = match.captures[0].text
            var escapes = p3.findAll(name)
            for (esc in escapes) {
                var hd = esc.captures[0].text
                var char = String.fromCodePoint(Conv.atoi(hd, 16))
                name = name.replace(esc.text, char)
            }
            System.print(name)
        }
    }
}
