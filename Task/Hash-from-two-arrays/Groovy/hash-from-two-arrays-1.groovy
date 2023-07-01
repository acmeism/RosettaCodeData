def keys = ['a','b','c']
def vals = ['aaa', 'bbb', 'ccc']
def hash = [:]
keys.eachWithIndex { key, i ->
 hash[key] = vals[i]
}
