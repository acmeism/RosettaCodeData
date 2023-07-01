import std.algorithm: swap;

void disjointSort(T, U)(T[] arr, U[] indexes)
in {
    if (arr.length == 0)
        assert(indexes.length == 0);
    else {
        foreach (idx; indexes)
            assert(idx >= 0 && idx < arr.length);
    }
} body {
    void quickSort(U* left, U* right) {
        if (right > left) {
            auto pivot = arr[left[(right - left) / 2]];
            auto r = right, l = left;
            do {
                while (arr[*l] < pivot) l++;
                while (arr[*r] > pivot) r--;
                if (l <= r) {
                    swap(arr[*l], arr[*r]);
                    swap(l, r);
                    l++;
                    r--;
                }
            } while (l <= r);
            quickSort(left, r);
            quickSort(l, right);
        }
    }

    if (arr.length == 0 || indexes.length == 0)
        return;
    quickSort(&indexes[0], &indexes[$-1]);
}

void main() {
    auto data = [7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 0.0];
    auto indexes = [6, 1, 1, 7];
    disjointSort(data, indexes);
    assert(data == [7.0, 0.0, 5.0, 4.0, 3.0, 2.0, 1.0, 6.0]);
}
