use itertools::sorted;

// sort by decorator using builtin function sort_by_cached_key
fn sort_by_cached(mut arr: Vec<&str>, decorator: impl Fn(&str) -> usize) -> Vec<&str> {
    arr.sort_by_cached_key(|t| decorator(*t));
    return arr;
}

// sort by decorator using Schwartzian transform
fn sort_by_decorator(arr: Vec<&str>, decorator: impl Fn(&str) -> usize) -> Vec<&str> {
    return sorted(
        arr
            .iter()
            .map(|e| (decorator(e), *e))
            .collect::<Vec<(usize, &str)>>()
    )
        .map(|e| e.1)
        .collect::<Vec<&str>>();
}

fn main() {
    let arr = Vec::from(["Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"]);
    println!("{:?} => ", arr);
    println!(
        "    cached:    {:?}",
        sort_by_cached(arr.clone(), |x| x.len())
    );
    println!(
        "    transform: {:?}",
        sort_by_decorator(arr, |x| x.len())
    );
}
