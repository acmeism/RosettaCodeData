function swap(aName, bName) {
  return ('(function(){ arguments[0] = aName; aName = bName; bName = arguments[0] })()'
    .replace(/aName/g, aName)
    .replace(/bName/g, bName)
  )
}
var x = 1
var y = 2
eval(swap('x', 'y'))
