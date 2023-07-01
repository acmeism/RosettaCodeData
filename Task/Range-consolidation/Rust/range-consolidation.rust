use std::fmt::{Display, Formatter};

// We could use std::ops::RangeInclusive, but we would have to extend it to
// normalize self (not much trouble) and it would not have to handle pretty
// printing for it explicitly. So, let's make rather an own type.

#[derive(Clone, Debug, PartialEq, PartialOrd)]
pub struct ClosedRange<Idx> {
    start: Idx,
    end: Idx,
}

impl<Idx> ClosedRange<Idx> {
    pub fn start(&self) -> &Idx {
        &self.start
    }

    pub fn end(&self) -> &Idx {
        &self.end
    }
}

impl<Idx: PartialOrd> ClosedRange<Idx> {
    pub fn new(start: Idx, end: Idx) -> Self {
        if start <= end {
            Self { start, end }
        } else {
            Self {
                end: start,
                start: end,
            }
        }
    }
}

// To make test input more compact
impl<Idx: PartialOrd> From<(Idx, Idx)> for ClosedRange<Idx> {
    fn from((start, end): (Idx, Idx)) -> Self {
        Self::new(start, end)
    }
}

// For the required print format
impl<Idx: Display> Display for ClosedRange<Idx> {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "[{}, {}]", self.start, self.end)
    }
}

fn consolidate<Idx>(a: &ClosedRange<Idx>, b: &ClosedRange<Idx>) -> Option<ClosedRange<Idx>>
where
    Idx: PartialOrd + Clone,
{
    if a.start() <= b.start() {
        if b.end() <= a.end() {
            Some(a.clone())
        } else if a.end() < b.start() {
            None
        } else {
            Some(ClosedRange::new(a.start().clone(), b.end().clone()))
        }
    } else {
        consolidate(b, a)
    }
}

fn consolidate_all<Idx>(mut ranges: Vec<ClosedRange<Idx>>) -> Vec<ClosedRange<Idx>>
where
    Idx: PartialOrd + Clone,
{
    // Panics for incomparable elements! So no NaN for floats, for instance.
    ranges.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let mut ranges = ranges.into_iter();
    let mut result = Vec::new();

    if let Some(current) = ranges.next() {
        let leftover = ranges.fold(current, |mut acc, next| {
            match consolidate(&acc, &next) {
                Some(merger) => {
                    acc = merger;
                }

                None => {
                    result.push(acc);
                    acc = next;
                }
            }

            acc
        });

        result.push(leftover);
    }

    result
}

#[cfg(test)]
mod tests {
    use super::{consolidate_all, ClosedRange};
    use std::fmt::{Display, Formatter};

    struct IteratorToDisplay<F>(F);

    impl<F, I> Display for IteratorToDisplay<F>
    where
        F: Fn() -> I,
        I: Iterator,
        I::Item: Display,
    {
        fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
            let mut items = self.0();

            if let Some(item) = items.next() {
                write!(f, "{}", item)?;
                for item in items {
                    write!(f, ", {}", item)?;
                }
            }

            Ok(())
        }
    }

    macro_rules! parameterized {
        ($($name:ident: $value:expr,)*) => {
            $(
                #[test]
                fn $name() {
                    let (input, expected) = $value;
                    let expected: Vec<_> = expected.into_iter().map(ClosedRange::from).collect();
                    let output = consolidate_all(input.into_iter().map(ClosedRange::from).collect());
                    println!("{}: {}", stringify!($name), IteratorToDisplay(|| output.iter()));
                    assert_eq!(expected, output);
                }
            )*
        }
    }

    parameterized! {
        single: (vec![(1.1, 2.2)], vec![(1.1, 2.2)]),
        touching: (vec![(6.1, 7.2), (7.2, 8.3)], vec![(6.1, 8.3)]),
        disjoint: (vec![(4, 3), (2, 1)], vec![(1, 2), (3, 4)]),
        overlap: (vec![(4.0, 3.0), (2.0, 1.0), (-1.0, -2.0), (3.9, 10.0)], vec![(-2.0, -1.0), (1.0, 2.0), (3.0, 10.0)]),
        integer: (vec![(1, 3), (-6, -1), (-4, -5), (8, 2), (-6, -6)], vec![(-6, -1), (1, 8)]),
    }
}

fn main() {
    // To prevent dead code and to check empty input
    consolidate_all(Vec::<ClosedRange<usize>>::new());

    println!("Run: cargo test -- --nocapture");
}
