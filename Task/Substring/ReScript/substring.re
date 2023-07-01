let s = "ABCDEFGH"
let from = 2
let length = 3

Js.log2("Original string: ", s)

Js.log(Js.String.substrAtMost(~from, ~length, s))
Js.log(Js.String.substr(~from, s))
Js.log(Js.String.substrAtMost(~from=0, ~length=(Js.String2.length(s) - 1), s))

Js.log(Js.String.substrAtMost(~from=(Js.String.indexOf("B", s)), ~length, s))
Js.log(Js.String.substrAtMost(~from=(Js.String.indexOf("BC", s)), ~length, s))
