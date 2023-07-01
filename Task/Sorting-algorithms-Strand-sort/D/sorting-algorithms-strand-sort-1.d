import std.stdio, std.container;

DList!T strandSort(T)(DList!T list) {
    static DList!T merge(DList!T left, DList!T right) {
        DList!T result;
        while (!left.empty && !right.empty) {
            if (left.front <= right.front) {
                result.insertBack(left.front);
                left.removeFront();
            } else {
                result.insertBack(right.front);
                right.removeFront();
            }
        }
        result.insertBack(left[]);
        result.insertBack(right[]);
        return result;
    }

    DList!T result, sorted, leftover;

    while (!list.empty) {
        leftover.clear();
        sorted.clear();
        sorted.insertBack(list.front);
        list.removeFront();
        foreach (item; list) {
            if (sorted.back <= item)
                sorted.insertBack(item);
            else
                leftover.insertBack(item);
        }
        result = merge(sorted, result);
        list = leftover;
    }

    return result;
}

void main() {
    auto lst = DList!int([-2,0,-2,5,5,3,-1,-3,5,5,0,2,-4,4,2]);
    foreach (e; strandSort(lst))
        write(e, " ");
}
