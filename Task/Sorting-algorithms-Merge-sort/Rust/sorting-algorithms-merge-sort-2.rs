pub fn merge_sort2<T: Copy + Ord>(v: &mut [T]) {
    sort(v, &mut Vec::new());

    fn sort<T: Copy + Ord>(v: &mut [T], t: &mut Vec<T>) {
        match v.len() {
            0 | 1 => (),
            // n if n <= 20 => insertion_sort(v),
            n => {
                let m = n / 2;
                if t.is_empty() {
                    t.reserve_exact(m);
                    t.resize(m, v[0]);
                }
                sort(&mut v[..m], t);
                sort(&mut v[m..], t);
                if v[m - 1] <= v[m] {
                    return;
                }
                copy(&v[..m], t);
                merge(&t[..m], v);
            }
        }
    }

    // merge a + b[a.len..] -> b
    #[inline(always)]
    fn merge<T: Copy + Ord>(a: &[T], b: &mut [T]) {
        let (mut i, mut j) = (0, a.len());
        for k in 0..b.len() {
            if i < a.len() && (j >= b.len() || a[i] <= b[j]) {
                b[k] = a[i];
                i += 1;
            } else {
                b[k] = b[j];
                j += 1;
            }
        }
    }

    #[inline(always)]
    fn copy<T: Copy>(src: &[T], dst: &mut [T]) {
        for i in 0..src.len() {
            dst[i] = src[i];
        }
    }
}
