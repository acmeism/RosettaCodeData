class Comparable:
    var Value

    func _init(_val):
        self.Value = _val

    func compare(_other : Comparable) -> int:
        # Here is the simple implementation of compare
        # for primitive type wrapper.
        return self.Value - _other.Value


func BubbleSortObjects(_array : Array) -> void:
    for i in range(_array.size() - 1):
        var swapped : bool = false
        for j in range(_array.size() - i - 1):
            if _array[j].compare(_array[j + 1]) > 0:
                var tmp = _array[j]
                _array[j] = _array[j + 1]
                _array[j + 1] = tmp
                swapped = true
        if not swapped:
            break
    return
