function swap(aName, bName) {
  eval('(function(){ arguments[0] = aName; aName = bName; bName = arguments[0] })()'
    .replace(/aName/g, aName)
    .replace(/bName/g, bName)
  )
}
var x = 1
var y = 2
swap('x', 'y')
