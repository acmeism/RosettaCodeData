function mergeSort(v) {
    if (v.length <= 1) {
        return v;
    }

    let m = Math.floor(v.length / 2);
    let l = mergeSort(v.slice(0, m));
    let r = mergeSort(v.slice(m));
    return merge(l, r);

    function merge(a, b) {
        let i = 0, j = 0;
        let n = a.length + b.length;
        let c = [];
        while (c.length < n) {
            if (i < a.length && (j >= b.length || a[i] < b[j])) {
                c.push(a[i++]);
            } else {
                c.push(b[j++]);
            }
        }
        return c;
    }
}

function mergeSortInPlace(v) {
    if (v.length <= 1) {
        return;
    }

    let m = Math.floor(v.length / 2);
    let l = v.slice(0, m);
    let r = v.slice(m);
    mergeSortInPlace(l);
    mergeSortInPlace(r);
    merge(l, r, v);

    // merge a + b -> c
    function merge(a, b, c) {
        let i = 0, j = 0;
        for (let k = 0; k < c.length; k++) {
            if (i < a.length && (j >= b.length || a[i] < b[j])) {
                c[k] = a[i++];
            } else {
                c[k] = b[j++];
            }
        }
    }
}

// even faster
function mergeSortInPlaceFast(v) {
    sort(v, 0, v.length, v.slice());

    function sort(v, lo, hi, t) {
        let n = hi - lo;
        if (n <= 1) {
            return;
        }
        let mid = lo + Math.floor(n / 2);
        sort(v, lo, mid, t);
        sort(v, mid, hi, t);
        for (let i = lo; i < hi; i++) {
            t[i] = v[i];
        }
        let i = lo, j = mid;
        for (let k = lo; k < hi; k++) {
            if (i < mid && (j >= hi || t[i] < t[j])) {
                v[k] = t[i++];
            } else {
                v[k] = t[j++];
            }
        }
    }
}
