fn aks_coefficients(k: usize) -> Vec<i64> {
	if k == 0 {
		vec![1i64]
	} else {
		let zero = Some(0i64);
		range(1, k).fold(vec![1i64, -1], |r, _| {
			let a = r.iter().chain(zero.iter());
			let b = zero.iter().chain(r.iter());
			a.zip(b).map(|(x, &y)| x-y).collect()
		})
	}
}
