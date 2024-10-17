// ==== main ==== //

fn main() {
    let results =

    amb(&["the", "that", "a"])              >> move |a|
    amb(&["frog", "elephant", "thing"])     >> move |b|
    amb(&["walked", "treaded", "grows"])    >> move |c|
    amb(&["slowly", "quickly"])             >> move |d|
    assert(joins(a, b))                     >> move |_|
    assert(joins(b, c))                     >> move |_|
    assert(joins(c, d))                     >> move |_|

    ret((a, b, c, d));

    for (a, b, c, d) in results {
        println!("{} {} {} {}", a, b, c, d);
    }
}

fn joins(x: &str, y: &str) -> bool {
    x.chars().last() == y.chars().next()
}

// ==== Amb ==== //

struct Amb<T: Iterator>(T);

impl<T: Iterator> IntoIterator for Amb<T> {
    type IntoIter = T;
    type Item = T::Item;
    fn into_iter(self) -> Self::IntoIter { self.0 }
}

impl<T, U, F> std::ops::Shr<F> for Amb<T>
where
    T: Iterator,
    U: Iterator,
    F: FnMut(T::Item) -> Amb<U>,
{
    type Output = Amb<std::iter::FlatMap<T, Amb<U>, F>>;
    fn shr(self, f: F) -> Self::Output {
        Self(self.0.flat_map(f))
    }
}

fn amb<I: IntoIterator>(i: I) -> Amb<I::IntoIter> {
    Amb(i.into_iter())
}

fn assert(x: bool) -> Amb<impl Iterator<Item = ()>> {
    Amb(std::iter::once(()).filter(move |_| x))
}

fn ret<T>(x: T) -> Amb<impl Iterator<Item = T>> {
    Amb(std::iter::once(x))
}
