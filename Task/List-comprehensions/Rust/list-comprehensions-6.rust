fn pyth(n: u32) -> impl Iterator<Item = [u32; 3]> {
    comp!(
        [x, y, z],
        for x in 1..=n,
        for y in x..=n,
        for z in y..=n,
        if x.pow(2) + y.pow(2) == z.pow(2)
    )
}
