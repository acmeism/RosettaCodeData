fn merge_sort<T: Copy + PartialOrd>(x: &mut [T]) {
	let n = x.len();
	let mut y = x.to_vec();
	let mut len = 1;
	while len < n {
		let mut i = 0;
		while i < n {
			if i + len >= n {
				y[i..].copy_from_slice(&x[i..]);
			} else if i + 2 * len > n {
				merge(&x[i..i+len], &x[i+len..], &mut y[i..]);				
			} else {
				merge(&x[i..i+len], &x[i+len..i+2*len], &mut y[i..i+2*len]);
			}
			i += 2 * len;
		}
		len *= 2;
		if len >= n {
			x.copy_from_slice(&y);
			return;
		}
		i = 0;
		while i < n {
			if i + len >= n {
				x[i..].copy_from_slice(&y[i..]);
			} else if i + 2 * len > n {
				merge(&y[i..i+len], &y[i+len..], &mut x[i..]);				
			} else {
				merge(&y[i..i+len], &y[i+len..i+2*len], &mut x[i..i+2*len]);
			}
			i += 2 * len;
		}
		len *= 2;
	}
}
