def words = new URL('http://www.puzzlers.org/pub/wordlists/unixdict.txt').text.readLines()
def groups = words.groupBy{ it.toList().sort() }
def bigGroupSize = groups.collect{ it.value.size() }.max()
def isBigAnagram = { it.value.size() == bigGroupSize }
println groups.findAll(isBigAnagram).collect{ it.value }.collect{ it.join(' ') }.join('\n')
