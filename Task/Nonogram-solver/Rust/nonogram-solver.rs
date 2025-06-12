use std::collections::HashSet;

// BitSet implementation
#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug)]
struct BitSet {
    bits: u64,
}

impl BitSet {
    fn empty() -> Self {
        BitSet { bits: 0 }
    }

    fn value(&self) -> u64 {
        self.bits
    }

    fn add(&self, item: usize) -> Self {
        BitSet { bits: self.bits | (1 << item) }
    }

    fn add_range(&self, start: usize, count: usize) -> Self {
        let mask = ((1 << (start + count)) - 1) & !((1 << start) - 1);
        BitSet { bits: self.bits | mask }
    }

    fn contains(&self, item: usize) -> bool {
        (self.bits & (1 << item)) != 0
    }

    fn shift_left_at(&self, index: usize) -> Self {
        let high_bits = (self.bits >> index) << (index + 1);
        let low_bits = self.bits & ((1 << index) - 1);
        BitSet { bits: high_bits | low_bits }
    }

    fn to_string(&self) -> String {
        format!("{:b}", self.bits)
    }
}

impl std::ops::BitAnd for BitSet {
    type Output = Self;

    fn bitand(self, rhs: Self) -> Self::Output {
        BitSet { bits: self.bits & rhs.bits }
    }
}

impl std::ops::BitOr for BitSet {
    type Output = Self;

    fn bitor(self, rhs: Self) -> Self::Output {
        BitSet { bits: self.bits | rhs.bits }
    }
}

fn generate(length: usize, runs: &[usize]) -> Vec<BitSet> {
    let mut list = Vec::new();
    let initial = BitSet::empty();
    let mut sums = vec![0; runs.len()];

    for i in 1..runs.len() {
        sums[i] = sums[i - 1] + runs[i - 1] + 1;
    }

    let initial = runs.iter().enumerate()
        .fold(initial, |acc, (i, &run)| acc.add_range(sums[i], run));

    let max = BitSet::empty().add(length);
    generate_recursive(&mut list, max, runs, &sums, initial, 0, 0);

    list
}

fn generate_recursive(
    result: &mut Vec<BitSet>,
    max: BitSet,
    runs: &[usize],
    sums: &[usize],
    mut current: BitSet,
    index: usize,
    mut shift: usize,
) {
    if index == runs.len() {
        result.push(current);
        return;
    }

    while current.value() < max.value() {
        generate_recursive(result, max, runs, sums, current, index + 1, shift);
        current = current.shift_left_at(sums[index] + shift);
        shift += 1;
    }
}

fn reduce(rows: &mut Vec<Vec<BitSet>>, columns: &mut Vec<Vec<BitSet>>) {
    let mut count = 1;

    while count > 0 {
        count = 0;

        // Check rows against columns
        for row_idx in 0..rows.len() {
            let all_on = rows[row_idx].iter().fold(rows[row_idx][0], |acc, &b| acc & b);
            let all_off = rows[row_idx].iter().fold(rows[row_idx][0], |acc, &b| acc | b);

            for col_idx in 0..columns.len() {
                // Remove column patterns where a cell should be on but isn't
                let before_len = columns[col_idx].len();
                columns[col_idx].retain(|c| !(all_on.contains(col_idx) && !c.contains(row_idx)));
                count += before_len - columns[col_idx].len();

                // Remove column patterns where a cell should be off but isn't
                let before_len = columns[col_idx].len();
                columns[col_idx].retain(|c| !(!all_off.contains(col_idx) && c.contains(row_idx)));
                count += before_len - columns[col_idx].len();
            }
        }

        // Check columns against rows
        for col_idx in 0..columns.len() {
            let all_on = columns[col_idx].iter().fold(columns[col_idx][0], |acc, &b| acc & b);
            let all_off = columns[col_idx].iter().fold(columns[col_idx][0], |acc, &b| acc | b);

            for row_idx in 0..rows.len() {
                // Remove row patterns where a cell should be on but isn't
                let before_len = rows[row_idx].len();
                rows[row_idx].retain(|r| !(all_on.contains(row_idx) && !r.contains(col_idx)));
                count += before_len - rows[row_idx].len();

                // Remove row patterns where a cell should be off but isn't
                let before_len = rows[row_idx].len();
                rows[row_idx].retain(|r| !(!all_off.contains(row_idx) && r.contains(col_idx)));
                count += before_len - rows[row_idx].len();
            }
        }
    }
}

fn solve(row_runs: &[Vec<usize>], column_runs: &[Vec<usize>]) {
    let column_len = column_runs.len();
    let row_len = row_runs.len();

    let mut rows: Vec<Vec<BitSet>> = row_runs.iter()
        .map(|row| generate(column_len, row))
        .collect();

    let mut columns: Vec<Vec<BitSet>> = column_runs.iter()
        .map(|column| generate(row_len, column))
        .collect();

    reduce(&mut rows, &mut columns);

    for row in rows {
        if row.len() != 1 {
            println!("{}", vec!['?'; column_len].into_iter().collect::<String>().chars().intersperse(' ').collect::<String>());
        } else {
            let mut s = format!("{:0width$b}", row[0].value(), width = column_len)
                .replace('1', "#")
                .replace('0', ".");

            // Reverse the string
            let s: String = s.chars().rev().collect();
            println!("{}", s.chars().intersperse(' ').collect::<String>());
        }
    }
}

fn parse_runs(input: &str) -> Vec<Vec<usize>> {
    input.split_whitespace()
        .map(|s| s.chars().map(|c| (c as u8 - b'A' + 1) as usize).collect())
        .collect()
}

fn main() {
    let test_cases = [
        ("C BA CB BB F AE F A B", "AB CA AE GA E C D C"),
        ("F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC",
            "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA"),
        ("CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC",
            "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF AAAAD BDG CEF CBDB BBB FC"),
        ("E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G",
            "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM")
    ];

    for (row_letters, column_letters) in test_cases.iter() {
        let row_runs = parse_runs(row_letters);
        let column_runs = parse_runs(column_letters);
        solve(&row_runs, &column_runs);
        println!();
    }
}

// Extension trait to add intersperse functionality
trait Intersperse {
    fn intersperse(self, separator: char) -> InterspersedIter<Self>
    where
        Self: Sized + Iterator<Item = char>;
}

impl<I> Intersperse for I
where
    I: Iterator<Item = char> + Sized,
{
    fn intersperse(self, separator: char) -> InterspersedIter<Self> {
        InterspersedIter {
            iter: self,
            separator,
            need_separator: false,
        }
    }
}

struct InterspersedIter<I> {
    iter: I,
    separator: char,
    need_separator: bool,
}

impl<I> Iterator for InterspersedIter<I>
where
    I: Iterator<Item = char>,
{
    type Item = char;

    fn next(&mut self) -> Option<Self::Item> {
        if self.need_separator {
            self.need_separator = false;
            return Some(self.separator);
        }

        match self.iter.next() {
            Some(val) => {
                self.need_separator = true;
                Some(val)
            }
            None => None,
        }
    }
}
