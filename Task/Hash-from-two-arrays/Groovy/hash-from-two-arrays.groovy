keys = ['a','b','c']
vals = ['aaa', 'bbb', 'ccc']
hash = [:]
keys.eachWithIndex { key, i ->
 hash[key] = vals[i]
}
