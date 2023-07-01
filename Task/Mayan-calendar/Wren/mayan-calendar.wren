import "/date" for Date
import "/fmt" for Fmt

var sacred = "Imix’ Ik’ Ak’bal K’an Chikchan Kimi Manik’ Lamat Muluk Ok Chuwen Eb Ben Hix Men K’ib’ Kaban Etz’nab’ Kawak Ajaw".split(" ")

var civil = "Pop Wo’ Sip Sotz’ Sek Xul Yaxk’in Mol Ch’en Yax Sak’ Keh Mak K’ank’in Muwan’ Pax K’ayab Kumk’u Wayeb’".split(" ")

var date1 = Date.new(2012, 12, 21)
var date2 = Date.new(2019, 4, 2)

var tzolkin = Fn.new { |date|
    var diff = (date - date1).days
    var rem = diff % 13
    if (rem < 0) rem = 13 + rem
    var num = (rem <= 9) ? rem + 4 : rem - 9
    rem = diff % 20
    if (rem <= 0) rem = 20 + rem
    return [num, sacred[rem-1]]
}

var haab = Fn.new { |date|
    var diff = (date - date2).days
    var rem = diff % 365
    if (rem < 0) rem = 365 + rem
    var month = civil[((rem+1)/20).floor]
    var last = (month == "Wayeb'") ? 5 : 20
    var d = rem%20 + 1
    if (d < last) return [d.toString, month]
    return ["Chum", month]
}

var longCount = Fn.new { |date|
    var diff = (date - date1).days
    diff = diff + 13*400*360
    var baktun = (diff/(400*360)).floor
    diff = diff % (400*360)
    var katun = (diff/(20 * 360)).floor
    diff = diff % (20*360)
    var tun = (diff/360).floor
    diff = diff % 360
    var winal = (diff/20).floor
    var kin = diff % 20
    return Fmt.swrite("$d.$d.$d.$d.$d", baktun, katun, tun, winal, kin)
}

var lord = Fn.new { |date|
    var diff = (date - date1).days
    var rem = diff % 9
    if (rem <= 0) rem = 9 + rem
    return Fmt.swrite("G$d", rem)
}

var dates = [
    "1961-10-06",
    "1963-11-21",
    "2004-06-19",
    "2012-12-18",
    "2012-12-21",
    "2019-01-19",
    "2019-03-27",
    "2020-02-29",
    "2020-03-01",
    "2071-05-16"
]
System.print(" Gregorian   Tzolk’in        Haab’              Long           Lord of")
System.print("   Date       # Name       Day Month            Count         the Night")
System.print("----------   --------    -------------        --------------  ---------")
Date.default = Date.isoDate
for (dt in dates) {
    var date = Date.parse(dt)
    var ns = tzolkin.call(date)
    var n = ns[0]
    var s = ns[1]
    var dm = haab.call(date)
    var d = dm[0]
    var m = dm[1]
    var lc = longCount.call(date)
    var l = lord.call(date)
    Fmt.lprint("$s   $2d $-8s $4s $-9s       $-14s     $s", [dt, n, s, d, m, lc, l])
}
