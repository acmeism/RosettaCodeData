extends Node2D


func BubbleSort(_array : Array) -> void:
    for i in range(_array.size() - 1):
        var swapped : bool = false
        for j in range(_array.size() - i - 1):
            if _array[j] > _array[j + 1]:
                var tmp = _array[j]
                _array[j] = _array[j + 1]
                _array[j + 1] = tmp
                swapped = true
        if not swapped:
            break
    return


func _ready() -> void:
    var array : Array = range(-10, 10)
    array.shuffle()

    print("Initial array:")
    print(array)

    BubbleSort(array)

    print("Sorted array:")
    print(array)
    return
