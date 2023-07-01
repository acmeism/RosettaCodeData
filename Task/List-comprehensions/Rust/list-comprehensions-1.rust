fn pyth(n: u32) -> impl Iterator<Item = [u32; 3]> {
    (1..=n).flat_map(move |x| {
        (x..=n).flat_map(move |y| {
            (y..=n).filter_map(move |z| {
                if x.pow(2) + y.pow(2) == z.pow(2) {
                    Some([x, y, z])
                } else {
                    None
                }
            })
        })
    })
}
