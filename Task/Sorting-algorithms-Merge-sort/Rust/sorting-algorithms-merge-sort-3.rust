pub fn merge_sort3<T: Copy + Ord>(v: &mut [T]) {
    match v.len() {
        0 | 1 => (),
        n => {
            let mut t = Vec::with_capacity(n);
            t.resize(n, v[0]);
            let mut p = 1;
            while p < n {
                p = merge_blocks(v, &mut t, p, n);
                if p >= n {
                    copy(&t, v);
                    return;
                }
                p = merge_blocks(&t, v, p, n);
            }
        }
    }

    #[inline(always)]
    fn merge_blocks<T: Copy + Ord>(a: &[T], b: &mut [T], p: usize, n: usize) -> usize {
        let mut i = 0;
        while i < n {
            if i + p >= n {
                copy(&a[i..], &mut b[i..])
            } else if i + p * 2 > n {
                merge(&a[i..i + p], &a[i + p..], &mut b[i..]);
            } else {
                merge(&a[i..i + p], &a[i + p..i + p * 2], &mut b[i..i + p * 2]);
            }
            i += p * 2;
        }
        p * 2
    }

    // merge a + b -> c
    #[inline(always)]
    fn merge<T: Copy + Ord>(a: &[T], b: &[T], c: &mut [T]) {
        let (mut i, mut j, mut k) = (0, 0, 0);
        while i < a.len() && j < b.len() {
            if a[i] < b[j] {
                c[k] = a[i];
                i += 1;
            } else {
                c[k] = b[j];
                j += 1;
            }
            k += 1;
        }
        if i < a.len() {
            copy(&a[i..], &mut c[k..]);
        }
        if j < b.len() {
            copy(&b[j..], &mut c[k..]);
        }
    }

    #[inline(always)]
    fn copy<T: Copy>(src: &[T], dst: &mut [T]) {
        for i in 0..src.len() {
            dst[i] = src[i];
        }
    }
}
