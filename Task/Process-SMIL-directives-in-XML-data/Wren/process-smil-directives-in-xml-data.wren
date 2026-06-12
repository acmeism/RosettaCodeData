import "./pattern" for Pattern

var xml = """
<?xml version="1.0" ?>
<smil>
<X3D>
  <Scene>
    <Viewpoint position="0 0 8" orientation="0 0 1 0"/>
    <PointLight color='1 1 1' location='0 2 0'/>
    <Shape>
      <Box size='2 1 2'>
        <animate attributeName="size" from="2 1 2"
                                        to="1 2 1" begin="0s" dur="10s"/>
      </Box>
      <Appearance>
        <Material diffuseColor='0.0 0.6 1.0'>
          <animate attributeName="diffuseColor" from="0.0 0.6 1.0"
                                                  to="1.0 0.4 0.0" begin="0s" dur="10s"/>
        </Material>
      </Appearance>
    </Shape>
  </Scene>
</X3D>
</smil>
"""

var extractValue = Fn.new { |s| s.replace("\"", "").split("=")[1] }

var interpolate = Fn.new { |from, to, begin, dur, t|
    if (begin >= t) return from
    if (begin + t >= dur) return to
    var mid = List.filled(3, 0)
    for (i in 0..2) {
        mid[i] = (from[i] * (dur - t) + to[i] * (t - begin)) / (dur - begin)
    }
    return mid
}

var smil = xml.indexOf("smil") > -1
if (!smil) {
    System.print(xml)
    return
}
xml = xml.replace("<smil>\n", "").replace("\n</smil>", "")
var animate = Pattern.new("<animate +1^///>")
var matches = animate.findAll(xml)
var mcount = matches.count
if (mcount == 0) {
    System.print(xml)
    return
}

var elem  = List.filled(mcount, null)
var attr  = List.filled(mcount, null)
var from  = List.filled(mcount, null)
var to    = List.filled(mcount, null)
var begin = List.filled(mcount, 0)
var dur   = List.filled(mcount, 0)
for (i in 0...mcount) {
    var match = matches[i]
    xml = xml.replace(match.text + "\n", "")
    var p = Pattern.new("+1/s")
    var items = p.splitAll(match.text[1..-3])
    attr[i] = extractValue.call(items[1])
    from[i] = [0] * 3
    from[i][0] = Num.fromString(items[2].replace("from=\"", ""))
    from[i][1] = Num.fromString(items[3])
    from[i][2] = Num.fromString(items[4].replace("\"", ""))
    to[i] = [0] * 3
    to[i][0] = Num.fromString(items[5].replace("to=\"", ""))
    to[i][1] = Num.fromString(items[6])
    to[i][2] = Num.fromString(items[7].replace("\"", ""))
    begin[i] = Num.fromString(extractValue.call(items[8]).replace("s", ""))
    dur[i]   = Num.fromString(extractValue.call(items[9]).replace("s", ""))
    p = Pattern.new("<[+1/w] %(attr[i])/='[+1^']'>")
    var matches2 = p.find(xml)
    elem[i] = matches2.capsText[0]
    p = Pattern.new(">\n+1/s<//%(elem[i])>")
    xml = p.replaceAll(xml, "/>")
}

for (t in [0, 2]) {
    var xml2 = xml
    for (i in 0...mcount) {
        var p = Pattern.new("<%(elem[i]) %(attr[i])/='[+1^']'//>")
        var sfrom = p.find(xml2).capsText[0]
        var mid = interpolate.call(from[i], to[i], begin[i], dur[i], t)
        var smid = mid.map { |n| n.toString }.join(" ")
        xml2 = xml2.replace("<%(elem[i]) %(attr[i])='%(sfrom)'/>", "<%(elem[i]) %(attr[i])='%(smid)'/>")
    }
    System.print("At t = %(t) seconds:\n")
    System.print(xml2)
    System.print()
}
