fn cocktail_shaker_sort<T: PartialOrd>(a: &mut [T]) {
    let mut begin = 0;
    let mut end = a.len();
    if end == 0 {
        return;
    }
    end -= 1;
    while begin < end {
        let mut new_begin = end;
        let mut new_end = begin;
        for i in begin..end {
            if a[i + 1] < a[i] {
                a.swap(i, i + 1);
                new_end = i;
            }
        }
        end = new_end;
        let mut i = end;
        while i > begin {
            if a[i] < a[i - 1] {
                a.swap(i, i - 1);
                new_begin = i;
            }
            i -= 1;
        }
        begin = new_begin;
    }
}

fn main() {
    let mut v = vec![5, 1, -6, 12, 3, 13, 2, 4, 0, 15];
    println!("before: {:?}", v);
    cocktail_shaker_sort(&mut v);
    println!("after:  {:?}", v);
}
