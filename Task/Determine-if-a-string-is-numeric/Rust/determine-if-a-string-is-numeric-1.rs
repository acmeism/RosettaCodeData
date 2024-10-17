// This function is not limited to just numeric types but rather anything that implements the FromStr trait.
fn parsable<T: FromStr>(s: &str) -> bool {
    s.parse::<T>().is_ok()
}
