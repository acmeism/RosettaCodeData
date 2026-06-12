class FixedSizeMap {
    construct new(map) {
        // copy the map so it cannot be mutated from the original reference
        _map = {}
        for (me in map.toList) _map[me.key] = me.value
    }

    containsKey(key) { _map[key] != null }

    count { _map.count }

    keys { _map.keys }

    values { _map.values }

    [key] { _map[key] }
    [key] =(value) {
        // do nothing if key doesn't already exist
        if (_map[key] != null) _map[key] = value
    }

    reset(key) {
        var t = _map[key].type
        // leave unaltered if no suitable default value
        _map[key] = (t == Num)    ? 0 :
                    (t == String) ? "":
                    (t == Bool)   ? false :
                    (t == List)   ? [] :
                    (t == Map)    ? {} : _map[key]
    }

    iterate(iterator)       { _map.iterate(iterator) }
    iteratorValue(iterator) { _map.iteratorValue(iterator) }

    toString { _map.toString }
}

var map = { "a": 1, "b": 2 }
var fsm = FixedSizeMap.new(map)
System.print(fsm)
System.print(fsm.count)
fsm["a"] = 3
fsm["b"] = 4
System.print(fsm)
System.print(fsm.containsKey("c"))
fsm["c"] = 5 // attempt to add a new key/value pair
System.print(fsm) // ignored
fsm.reset("a")
System.print(fsm)
System.print(fsm.keys.toList)
System.print(fsm.values.toList)
for (me in fsm) System.print([me.key, me.value])
