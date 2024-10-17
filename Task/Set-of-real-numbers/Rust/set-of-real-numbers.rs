#[derive(Debug)]
enum SetOperation {
    Union,
    Intersection,
    Difference,
}

#[derive(Debug, PartialEq)]
enum RangeType {
    Inclusive,
    Exclusive,
}

#[derive(Debug)]
struct CompositeSet<'a> {
    operation: SetOperation,
    a: &'a RealSet<'a>,
    b: &'a RealSet<'a>,
}

#[derive(Debug)]
struct RangeSet {
    range_types: (RangeType, RangeType),
    start: f64,
    end: f64,
}

#[derive(Debug)]
enum RealSet<'a> {
    RangeSet(RangeSet),
    CompositeSet(CompositeSet<'a>),
}

impl RangeSet {
    fn compare_start(&self, n: f64) -> bool {
        if self.range_types.0 == RangeType::Inclusive {
            self.start <= n
        } else {
            self.start < n
        }
    }

    fn compare_end(&self, n: f64) -> bool {
        if self.range_types.1 == RangeType::Inclusive {
            n <= self.end
        } else {
            n < self.end
        }
    }
}

impl<'a> RealSet<'a> {
    fn new(start_type: RangeType, start: f64, end: f64, end_type: RangeType) -> Self {
        RealSet::RangeSet(RangeSet {
            range_types: (start_type, end_type),
            start,
            end,
        })
    }

    fn operation(&'a self, other: &'a Self, operation: SetOperation) -> Self {
        RealSet::CompositeSet(CompositeSet {
            operation,
            a: self,
            b: other,
        })
    }

    fn union(&'a self, other: &'a Self) -> Self {
        self.operation(other, SetOperation::Union)
    }

    fn intersection(&'a self, other: &'a Self) -> Self {
        self.operation(other, SetOperation::Intersection)
    }

    fn difference(&'a self, other: &'a Self) -> Self {
        self.operation(other, SetOperation::Difference)
    }

    fn contains(&self, n: f64) -> bool {
        if let RealSet::RangeSet(range) = self {
            range.compare_start(n) && range.compare_end(n)
        } else if let RealSet::CompositeSet(range) = self {
            match range.operation {
                SetOperation::Union => range.a.contains(n) || range.b.contains(n),
                SetOperation::Intersection => range.a.contains(n) && range.b.contains(n),
                SetOperation::Difference => range.a.contains(n) && !range.b.contains(n),
            }
        } else {
            unimplemented!();
        }
    }
}

fn make_contains_phrase(does_contain: bool) -> &'static str {
    if does_contain {
        "contains"
    } else {
        "does not contain"
    }
}

use RangeType::*;

fn main() {
    for (set_name, set) in [
        (
            "(0, 1] ∪ [0, 2)",
            RealSet::new(Exclusive, 0.0, 1.0, Inclusive)
                .union(&RealSet::new(Inclusive, 0.0, 2.0, Exclusive)),
        ),
        (
            "[0, 2) ∩ (1, 2]",
            RealSet::new(Inclusive, 0.0, 2.0, Exclusive)
                .intersection(&RealSet::new(Exclusive, 1.0, 2.0, Inclusive)),
        ),
        (
            "[0, 3) − (0, 1)",
            RealSet::new(Inclusive, 0.0, 3.0, Exclusive)
                .difference(&RealSet::new(Exclusive, 0.0, 1.0, Exclusive)),
        ),
        (
            "[0, 3) − [0, 1]",
            RealSet::new(Inclusive, 0.0, 3.0, Exclusive)
                .difference(&RealSet::new(Inclusive, 0.0, 1.0, Inclusive)),
        ),
    ] {
        println!("Set {}", set_name);

        for i in [0.0, 1.0, 2.0] {
            println!("- {} {}", make_contains_phrase(set.contains(i)), i);
        }
    }
}
