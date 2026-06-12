use std::fmt;

#[derive(Debug, Clone)]
struct Range {
    low: i32,
    high: i32,
}

impl Range {
    fn new(low: i32, high: i32) -> Self {
        Range { low, high }
    }
}

impl fmt::Display for Range {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}-{}", self.low, self.high)
    }
}

struct Ranges {
    ranges: Vec<Range>,
}

impl Ranges {
    fn new() -> Self {
        Ranges {
            ranges: Vec::new(),
        }
    }

    fn from_ranges(ranges: Vec<(i32, i32)>) -> Self {
        let mut result = Ranges::new();
        for (low, high) in ranges {
            result.ranges.push(Range::new(low, high));
        }
        result
    }

    fn add(&mut self, n: i32) {
        // Find the position to insert or modify
        for i in 0..self.ranges.len() {
            if n + 1 < self.ranges[i].low {
                // Insert new range before this position
                self.ranges.insert(i, Range::new(n, n));
                return;
            }
            if n > self.ranges[i].high + 1 {
                continue;
            }

            // n is adjacent to or within this range
            if n + 1 == self.ranges[i].low {
                self.ranges[i].low = n;
            } else if n == self.ranges[i].high + 1 {
                self.ranges[i].high = n;
            } else {
                // n is already within the range
                return;
            }

            // Now handle merging - we need to be careful about borrowing
            self.merge_at_index(i);
            return;
        }

        // If we get here, add to the end
        self.ranges.push(Range::new(n, n));
    }

    fn merge_at_index(&mut self, i: usize) {
        // Check if we can merge with previous range
        if i > 0 && self.ranges[i - 1].high + 1 == self.ranges[i].low {
            let prev_low = self.ranges[i - 1].low;
            self.ranges[i].low = prev_low;
            self.ranges.remove(i - 1);
            // Index shifts down by 1 after removal
            let new_i = i - 1;

            // Check if we can merge with next range (adjust index after removal)
            if new_i + 1 < self.ranges.len() && self.ranges[new_i + 1].low - 1 == self.ranges[new_i].high {
                let next_high = self.ranges[new_i + 1].high;
                self.ranges[new_i].high = next_high;
                self.ranges.remove(new_i + 1);
            }
        } else if i + 1 < self.ranges.len() && self.ranges[i + 1].low - 1 == self.ranges[i].high {
            // Check if we can merge with next range
            let next_high = self.ranges[i + 1].high;
            self.ranges[i].high = next_high;
            self.ranges.remove(i + 1);
        }
    }

    fn remove(&mut self, n: i32) {
        for i in 0..self.ranges.len() {
            if n < self.ranges[i].low {
                return;
            }

            if n == self.ranges[i].low {
                self.ranges[i].low += 1;
                if self.ranges[i].low > self.ranges[i].high {
                    self.ranges.remove(i);
                }
                return;
            }

            if n == self.ranges[i].high {
                self.ranges[i].high -= 1;
                if self.ranges[i].high < self.ranges[i].low {
                    self.ranges.remove(i);
                }
                return;
            }

            if n > self.ranges[i].low && n < self.ranges[i].high {
                let low = self.ranges[i].low;
                self.ranges[i].low = n + 1;
                self.ranges.insert(i, Range::new(low, n - 1));
                return;
            }
        }
    }

    fn is_empty(&self) -> bool {
        self.ranges.is_empty()
    }
}

impl fmt::Display for Ranges {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if !self.is_empty() {
            let mut iter = self.ranges.iter();
            if let Some(first) = iter.next() {
                write!(f, "{}", first)?;
                for range in iter {
                    write!(f, ",{}", range)?;
                }
            }
        }
        Ok(())
    }
}

fn test_add(r: &mut Ranges, n: i32) {
    r.add(n);
    println!("       add {:2} => {}", n, r);
}

fn test_remove(r: &mut Ranges, n: i32) {
    r.remove(n);
    println!("    remove {:2} => {}", n, r);
}

fn test1() {
    let mut r = Ranges::new();
    println!("Start: \"{}\"", r);
    test_add(&mut r, 77);
    test_add(&mut r, 79);
    test_add(&mut r, 78);
    test_remove(&mut r, 77);
    test_remove(&mut r, 78);
    test_remove(&mut r, 79);
}

fn test2() {
    let mut r = Ranges::from_ranges(vec![(1, 3), (5, 5)]);
    println!("Start: \"{}\"", r);
    test_add(&mut r, 1);
    test_remove(&mut r, 4);
    test_add(&mut r, 7);
    test_add(&mut r, 8);
    test_add(&mut r, 6);
    test_remove(&mut r, 7);
}

fn test3() {
    let mut r = Ranges::from_ranges(vec![(1, 5), (10, 25), (27, 30)]);
    println!("Start: \"{}\"", r);
    test_add(&mut r, 26);
    test_add(&mut r, 9);
    test_add(&mut r, 7);
    test_remove(&mut r, 26);
    test_remove(&mut r, 9);
    test_remove(&mut r, 7);
}

fn main() {
    test1();
    println!();
    test2();
    println!();
    test3();
}
