import "std/vec.zc"

fn proper_divisors(n: int) -> Vec<int> {
    let divs = Vec<int>::new();
    if n < 1 { return divs; }
    let divs2 = Vec<int>::new();
    let i = 1;
    let k = (n % 2 == 0) ? 1 : 2;
    while i * i <= n {
        if n % i == 0 {
            divs << i;
            let j = n / i;
            if j != i { divs2 << j; }
        }
        i += k;
    }
    if divs2.length() {
        divs2.reverse();
        for l in 0..divs2.length() { divs << divs2[l]; }
    }
    divs.remove(divs.length() - 1);
    return divs;
}

fn powerset(set: Vec<int>*) -> Vec<Vec<int>> {
    if set.length() == 0 {
        let res = Vec<Vec<int>>::new();
        let e = Vec<int>::new();
        res << e;
        return res;
    }
    let head = set.get(0);
    let tail = set.clone();
    tail.remove(0);
    let p1 = powerset(&tail);
    let p2 = Vec<Vec<int>>::new();
    let p3 = powerset(&tail);
    for s in p3 {
        let h = Vec<int>::new();
        h << head;
        for i in 0..s.length() { h << s.get(i); }
        p2 << h;
    }
    for e in p2 { p1 << e; }
    return p1;
}

fn is_practical(n: int) -> bool {
    if n == 1 { return true; }
    let divs = proper_divisors(n);
    let subsets = powerset(&divs);
    autofree let found = (bool*)calloc(n, sizeof(bool));
    let count = 0;
    for i in 0..subsets.length() {
        let subset = subsets[i];
        let sum = 0;
        for j in 0..subset.length() { sum += subset[j]; }
        if sum > 0 && sum < n && !found[sum] {
            found[sum] = true;
            if ++count == n - 1 {
                for k in (i + 1)..subsets.length() { subsets[k].free(); }
                return true;
            }
        }
    }
    return false;
}

fn main() {
    println "In the range 1..333, there are:";
    let practical = Vec<int>::new();
    for i in 1..=333 {
        if is_practical(i) { practical << i; }
    }
    println  "  {practical.length()} practical numbers";
    print    "  The first ten are [";
    for i in 0..10 { print "{practical[i]}, "; }
    println "\b\b]";
    print    "  The final ten are [";
    let len = practical.length();
    for i in (len - 10)..len { print "{practical[i]}, "; }
    println "\b\b]";
    println "\n666 is practical: {is_practical(666)}";
}
