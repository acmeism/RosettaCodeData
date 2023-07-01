struct Digits {
    rest: usize,
    base: usize,
}

impl Iterator for Digits {
    type Item = usize;

    fn next(&mut self) -> Option<usize> {
        if self.rest == 0 {
            return None;
        }
        let (digit, rest) = (self.rest % self.base, self.rest / self.base);
        self.rest = rest;
        Some(digit)
    }
}

fn digits(num: usize, base: usize) -> Digits {
    Digits { rest: num, base: base }
}

struct FairSharing {
    participants: usize,
    index: usize,
}

impl Iterator for FairSharing {
    type Item = usize;
    fn next(&mut self) -> Option<usize> {
        let digit_sum: usize = digits(self.index, self.participants).sum();
        let selected = digit_sum % self.participants;
        self.index += 1;
        Some(selected)
    }
}

fn fair_sharing(participants: usize) -> FairSharing {
    FairSharing { participants: participants, index: 0 }
}

fn main() {
    for i in vec![2, 3, 5, 7] {
        println!("{}: {:?}", i, fair_sharing(i).take(25).collect::<Vec<usize>>());
    }
}
