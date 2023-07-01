var s = "abc123"
var t = "abc\t123\%"
var u = "\U0001F64A\U0001F680"
var v = "%("abc" * 3)"
var w = """a"bc""def\n%(v)"""

System.print([s, t, u, v, w])
