import "io" for File
import "os" for Process
import "timer" for Timer
import "./pattern" for Pattern
import "./fmt" for Fmt
import "./iterate" for Indexed

var digits = "0123456789"
var p = Pattern.new("+1/s")

var separateHouseNumber = Fn.new { |address|
    var len = address.count
    var splits = p.splitAll(address)
    var size = splits.count
    var last = splits[-1]
    var penult = splits[-2]
    var house
    if (digits.contains(last[0])) {
        if (size > 2 && digits.contains(penult[0]) && !penult.startsWith("194")) {
            house = penult + " " + last
        } else {
            house = last
        }
    } else if (size > 2) {
        house = penult + " " + last
    } else {
        house = ""
    }
    var street = address.take(len - house.count).join().trimEnd()
    return [street, house]
}

var addresses = [
    "Plataanstraat 5",
    "Straat 12",
    "Straat 12 II",
    "Dr. J. Straat   12",
    "Dr. J. Straat 12 a",
    "Dr. J. Straat 12-14",
    "Laan 1940 - 1945 37",
    "Plein 1940 2",
    "1213-laan 11",
    "16 april 1944 Pad 1",
    "1e Kruisweg 36",
    "Laan 1940-'45 66",
    "Laan '40-'45",
    "Langeloërduinen 3 46",
    "Marienwaerdt 2e Dreef 2",
    "Provincialeweg N205 1",
    "Rivium 2e Straat 59.",
    "Nieuwe gracht 20rd",
    "Nieuwe gracht 20rd 2",
    "Nieuwe gracht 20zw /2",
    "Nieuwe gracht 20zw/3",
    "Nieuwe gracht 20 zw/4",
    "Bahnhofstr. 4",
    "Wertstr. 10",
    "Lindenhof 1",
    "Nordesch 20",
    "Weilstr. 6",
    "Harthauer Weg 2",
    "Mainaustr. 49",
    "August-Horch-Str. 3",
    "Marktplatz 31",
    "Schmidener Weg 3",
    "Karl-Weysser-Str. 6"
]

var htmlHeader = """
<html>
<head>
<title>Rosetta Code - Start a Web Browser</title>
<meta charset="UTF-8">
</head>
<body bgcolor="#e6e6ff">
<p align="center">
<font face="Arial, sans-serif" size="5">Split the house number from the street name</font>
</p>
<p align="center">
<table border="2"> <tr bgcolor="#9bbb59">
<th>Address</th><th>Street</th><th>House Number</th>
"""

var htmlFooter = """
</table>
</p>
</body>
</html>
"""

File.create("test.html") { |f|
    f.writeBytes(htmlHeader + "\n")
    for (se in Indexed.new(addresses)) {
        var color = (se.index & 1 == 0) ? "#ebf1de" : "#d8e4bc"
        var address = se.value
        var res = separateHouseNumber.call(address)
        var street = res[0]
        var house = res[1]
        if (house == "") house = "(none)"
        f.writeBytes("<tr bgcolor=%(color)><td>%(address)</td><td>%(street)</td><td>%(house)</td></tr>\n")
    }
    f.writeBytes(htmlFooter + "\n")
}
Process.exec("firefox test.html")  // or whatever browser you use
File.flushAll()                    // flush all streams after user has closed the browser
Timer.wait(2000)                   // wait 2 seconds
File.delete("test.html")           // remove the file
