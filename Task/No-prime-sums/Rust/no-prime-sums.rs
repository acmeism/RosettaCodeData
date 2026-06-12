/// Our powerset grows very slowly, and at one element at a time, so I've decided to move
/// bookkeeping into a separate class to simplify the logic
pub struct Powerset {
    elements: Vec<Vec<u64>>,
}

impl Powerset {
    pub fn new(n: u64) -> Powerset {
        Powerset {
            elements: vec![vec![], vec![n]],
        }
    }

    /// Returns only the values inserted that generated the powerset
    pub fn ones(&self) -> impl Iterator<Item = &u64> {
        self.sets().filter(|inner| inner.len() == 1).flatten()
    }

    pub fn sets(&self) -> impl Iterator<Item = &[u64]> {
        self.elements.iter().map(Vec::as_slice)
    }

    /// Add a copy of our list to our original list with `n` added to each set
    pub fn add(&mut self, n: u64) {
        let new = self.elements.clone().into_iter().map(|mut x| {
            x.push(n);

            x
        });

        self.elements.extend(new);
    }
}

#[cfg(feature = "stretch_goal")]
mod consts {
    pub const ELEMS: usize = 10;
    pub const SIEVE: u64 = 99_999_999;
}
#[cfg(not(feature = "stretch_goal"))]
mod consts {
    pub const ELEMS: usize = 8;
    pub const SIEVE: u64 = 99_999;
}

static PRIME_SIEVE: std::sync::LazyLock<Vec<bool>> = std::sync::LazyLock::new(|| {
    let n = consts::SIEVE;
    let mut b = vec![true; n as usize];

    b[0] = false;
    b[1] = false;

    for i in 2..n.isqrt() {
        if b[i as usize] {
            for j in (i * i..n).step_by(i as usize) {
                b[j as usize] = false;
            }
        }
    }

    b
});

/// To test all subsequences, we initially create a powerset starting with `1` which creates the
/// powerset `[[], [1]]`. If any sum of subsequences plus the next number in the sequence is
/// composite, we add that number to the powerset which doubles it, and finally return sets that
/// contain exactly one element.
fn seq(seq_type: SeqType) -> Vec<u64> {
    let seq = match seq_type {
        SeqType::Both => (2..).step_by(1),
        SeqType::Even => (2..).step_by(2),
        SeqType::Odds => (3..).step_by(2),
    };

    let mut powerset = Powerset::new(1); // [[], [1]]
    'next: for i in seq {
        for set in powerset.sets() {
            // Note: [].sum() == 0
            if PRIME_SIEVE[i + set.iter().sum::<u64>() as usize] {
                continue 'next;
            }
        }

        powerset.add(i as u64); // [[], [1], [i], [1, i]]

        if powerset.ones().count() == consts::ELEMS {
            break 'next;
        }
    }

    powerset.ones().cloned().collect() // [[1], [i], [j], ...]
}

#[cfg(feature = "stretch_goal")]
fn run_time(s: SeqType) -> (Vec<u64>, core::time::Duration) {
    let start_time = std::time::Instant::now();
    let ret = seq(s);
    (ret, start_time.elapsed())
}

enum SeqType {
    Both,
    Even,
    Odds,
}

const OUT: [(&str, SeqType); 3] = [
    (" ", SeqType::Both),
    (" odd ", SeqType::Odds),
    (" even ", SeqType::Even),
];

fn main() {
    // Populate the sieve now
    std::sync::LazyLock::force(&PRIME_SIEVE);

    println!("Sequence, starting with 1, then:\n");

    for (what, seq_type) in OUT {
        println!(
            "lexicographically earliest{what}integer such that no subsequence sums to a prime:"
        );

        #[cfg(not(feature = "stretch_goal"))]
        println!("{:?}\n", seq(seq_type));

        #[cfg(feature = "stretch_goal")]
        {
            let (seq, elapsed) = run_time(seq_type);
            println!("{seq:?} (took {elapsed:?})\n");
        }
    }
}
