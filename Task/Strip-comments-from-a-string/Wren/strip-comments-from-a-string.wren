var markers = ["#", ";"]

var stripComments = Fn.new { |s|
   for (marker in markers) {
       var t = s.split(marker)
       if (t.count > 1) return t[0].trim()
   }
   return s.trim()
}

var strings = [
    " apples, pears # and bananas",
    " apples, pears ; and bananas",
    " apples, pears \t     "
]

for (s in strings) {
    var t = stripComments.call(s)
    System.print("'%(s)' -> '%(t)'")
}
