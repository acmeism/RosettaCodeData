var Roman = {
  Values: [['CM', 900],  ['CD', 400], ['XC',  90], ['XL',  40], ['IV', 4],
           ['IX',   9], ['V',   5], ['X',   10], ['L',  50],
           ['C',  100], ['M', 1000], ['I',    1], ['D',  500]],
  UnmappedStr : 'Q',
  parse: function(str) {
    var result = 0
    for (var i=0; i<Roman.Values.length; ++i) {
      var pair = Roman.Values[i]
      var key = pair[0]
      var value = pair[1]
      var regex = RegExp(key)
      while (str.match(regex)) {
        result += value
        str = str.replace(regex, Roman.UnmappedStr)
      }
    }
    return result
  }
}

var test_data = ['MCMXC', 'MDCLXVI', 'MMVIII']
for (var i=0; i<test_data.length; ++i) {
  var test_datum = test_data[i]
  print(test_datum + ": " + Roman.parse(test_datum))
}
