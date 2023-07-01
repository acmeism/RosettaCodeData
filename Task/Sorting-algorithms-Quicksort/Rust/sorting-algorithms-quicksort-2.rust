fn main() {
    let numbers = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1];
    println!("{:?}\n", quick_sort(numbers.iter()));
}

fn quick_sort<T, E>(mut v: T) -> Vec<E>
where
    T: Iterator<Item = E>,
    E: PartialOrd,
{
    match v.next() {
        None => Vec::new(),

        Some(pivot) => {
            let (lower, higher): (Vec<_>, Vec<_>) = v.partition(|it| it < &pivot);
            let lower = quick_sort(lower.into_iter());
            let higher = quick_sort(higher.into_iter());
            lower.into_iter()
                .chain(core::iter::once(pivot))
                .chain(higher.into_iter())
                .collect()
        }
    }
}
