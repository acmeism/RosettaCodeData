function swap(a, i, j){
    var t = a[i]
    a[i] = a[j]
    a[j] = t
}

// Heap Sort

function heap_sort(a){
    var n = a.length

    function heapify(i){
        var t = a[i]
        while (true){
            var l = 2 * i + 1, r = l + 1
            var m = r < n ? (a[l] > a[r] ? l : r) : (l < n ? l : i)
            if (m != i && a[m] > t){
                a[i] = a[m]
                i = m
            }
            else{
                break
            }
        }
        a[i] = t;
    }

    for (let i = Math.floor(n / 2) - 1; i >= 0; i--){
        heapify(i)
    }

    for (let i = n - 1; i >= 1; i--){
        swap(a, 0, i)
        n--
        heapify(0)
    }
}

// Merge Sort

function merge_sort(a){
    var b = new Array(a.length)

    function rec(l, r){
        if (l < r){
            var m = Math.floor((l + r) / 2)
            rec(l, m)
            rec(m + 1, r)

            var i = l, j = m + 1, k = 0;

            while (i <= m && j <= r) b[k++] = (a[i] > a[j] ? a[j++] : a[i++])
            while (j <= r) b[k++] = a[j++]
            while (i <= m) b[k++] = a[i++]

            for (k = l; k <= r; k++){
                a[k] = b[k - l]
            }
        }
    }

    rec(0, a.length-1)
}

// Quick Sort

function quick_sort(a){
    function rec(l, r){
        if (l < r){
            var p = a[l + Math.floor((r - l + 1)*Math.random())]

            var i = l, j = l, k = r
            while (j <= k){
                if (a[j] < p){
                    swap(a, i++, j++)
                }
                else if (a[j] > p){
                    swap(a, j, k--)
                }
                else{
                    j++
                }
            }

            rec(l, i - 1)
            rec(k + 1, r)
        }
    }

    rec(0, a.length - 1)
}

// Shell Sort

function shell_sort(a){
    var n = a.length
    var gaps = [100894, 44842, 19930, 8858, 3937, 1750, 701, 301, 132, 57, 23, 10, 4, 1]

    for (let x of gaps){
        for (let i = x; i < n; i++){
            var t = a[i], j;
            for (j = i; j >= x && a[j - x] > t; j -= x){
                a[j] = a[j - x];
            }
            a[j] = t;
        }
    }
}

// Comb Sort (+ Insertion sort optimization)

function comb_sort(a){
    var n = a.length

    for (let x = n; x >= 10; x = Math.floor(x / 1.3)){
        for (let i = 0; i + x < n; i++){
            if (a[i] > a[i + x]){
                swap(a, i, i + x)
            }
        }
    }

    for (let i = 1; i < n; i++){
        var t = a[i], j;
        for (j = i; j > 0 && a[j - 1] > t; j--){
            a[j] = a[j - 1]
        }
        a[j] = t;
    }
}

// Test

function test(f, g, e){
    var res = ""

    for (let n of e){
        var a = new Array(n)

        var s = 0
        for (let k = 0; k < 10; k++){
            for (let i = 0; i < n; i++){
                a[i] = g(i)
            }

            var start = Date.now()
            f(a)

            s += Date.now() - start
        }

        res += Math.round(s / 10) + "\t"
    }

    return res
}

// Main

var e = [5000, 10000, 100000, 500000, 1000000, 2000000]

var sOut = "Test times in ms\n\nElements\t" + e.join("\t") + "\n\n"

sOut += "*All ones*\n"
sOut += "heap_sort\t" + test(heap_sort, (x => 1), e) + "\n"
sOut += "quick_sort\t" + test(quick_sort, (x => 1), e) + "\n"
sOut += "merge_sort\t" + test(merge_sort, (x => 1), e) + "\n"
sOut += "shell_sort\t" + test(shell_sort, (x => 1), e) + "\n"
sOut += "comb_sort\t" + test(comb_sort, (x => 1), e) + "\n\n"

sOut += "*Sorted*\n"
sOut += "heap_sort\t" + test(heap_sort, (x => x), e) + "\n"
sOut += "quick_sort\t" + test(quick_sort, (x => x), e) + "\n"
sOut += "merge_sort\t" + test(merge_sort, (x => x), e) + "\n"
sOut += "shell_sort\t" + test(shell_sort, (x => x), e) + "\n"
sOut += "comb_sort\t" + test(comb_sort, (x => x), e) + "\n\n"

sOut += "*Random*\n"
sOut += "heap_sort\t" + test(heap_sort, (x => Math.random()), e) + "\n"
sOut += "quick_sort\t" + test(quick_sort, (x => Math.random()), e) + "\n"
sOut += "merge_sort\t" + test(merge_sort, (x => Math.random()), e) + "\n"
sOut += "shell_sort\t" + test(shell_sort, (x => Math.random()), e) + "\n"
sOut += "comb_sort\t" + test(comb_sort, (x => Math.random()), e) + "\n"

console.log(sOut)
