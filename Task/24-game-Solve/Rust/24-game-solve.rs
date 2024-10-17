#[derive(Clone, Copy, Debug)]
enum Operator {
    Sub,
    Plus,
    Mul,
    Div,
}

#[derive(Clone, Debug)]
struct Factor {
    content: String,
    value: i32,
}

fn apply(op: Operator, left: &[Factor], right: &[Factor]) -> Vec<Factor> {
    let mut ret = Vec::new();
    for l in left.iter() {
        for r in right.iter() {
            use Operator::*;
            ret.push(match op {
                Sub if l.value > r.value => Factor {
                    content: format!("({} - {})", l.content, r.content),
                    value: l.value - r.value,
                },
                Plus => Factor {
                    content: format!("({} + {})", l.content, r.content),
                    value: l.value + r.value,
                },
                Mul => Factor {
                    content: format!("({} x {})", l.content, r.content),
                    value: l.value * r.value,
                },
                Div if l.value >= r.value && r.value > 0 && l.value % r.value == 0 => Factor {
                    content: format!("({} / {})", l.content, r.content),
                    value: l.value / r.value,
                },
                _ => continue,
            })
        }
    }
    ret
}

fn calc(op: [Operator; 3], numbers: [i32; 4]) -> Vec<Factor> {
    fn calc(op: &[Operator], numbers: &[i32], acc: &[Factor]) -> Vec<Factor> {
        use Operator::*;
        if op.is_empty() {
            return Vec::from(acc)
        }
        let mut ret = Vec::new();
        let mono_factor = [Factor {
            content: numbers[0].to_string(),
            value: numbers[0],
        }];
        match op[0] {
            Mul => ret.extend_from_slice(&apply(op[0], acc, &mono_factor)),
            Div => {
                ret.extend_from_slice(&apply(op[0], acc, &mono_factor));
                ret.extend_from_slice(&apply(op[0], &mono_factor, acc));
            },
            Sub => {
                ret.extend_from_slice(&apply(op[0], acc, &mono_factor));
                ret.extend_from_slice(&apply(op[0], &mono_factor, acc));
            },
            Plus => ret.extend_from_slice(&apply(op[0], acc, &mono_factor)),
        }
        calc(&op[1..], &numbers[1..], &ret)
    }
    calc(&op, &numbers[1..], &[Factor { content: numbers[0].to_string(), value: numbers[0] }])
}

fn solutions(numbers: [i32; 4]) -> Vec<Factor> {
    use std::collections::hash_set::HashSet;
    let mut ret = Vec::new();
    let mut hash_set = HashSet::new();

    for ops in OpIter(0) {
        for o in orders().iter() {
            let numbers = apply_order(numbers, o);
            let r = calc(ops, numbers);
            ret.extend(r.into_iter().filter(|&Factor { value, ref content }| value == 24 && hash_set.insert(content.to_owned())))
        }
    }
    ret
}

fn main() {
    let mut numbers = Vec::new();
    if let Some(input) = std::env::args().skip(1).next() {
        for c in input.chars() {
            if let Ok(n) = c.to_string().parse() {
                numbers.push(n)
            }
            if numbers.len() == 4 {
                let numbers = [numbers[0], numbers[1], numbers[2], numbers[3]];
                let solutions = solutions(numbers);
                let len = solutions.len();
                if len == 0 {
                    println!("no solution for {}, {}, {}, {}", numbers[0], numbers[1], numbers[2], numbers[3]);
                    return
                }
                println!("solutions for {}, {}, {}, {}", numbers[0], numbers[1], numbers[2], numbers[3]);
                for s in solutions {
                    println!("{}", s.content)
                }
                println!("{} solutions found", len);
                return
            }
        }
    } else {
        println!("empty input")
    }
}


struct OpIter (usize);

impl Iterator for OpIter {
    type Item = [Operator; 3];
    fn next(&mut self) -> Option<[Operator; 3]> {
        use Operator::*;
        const OPTIONS: [Operator; 4] = [Mul, Sub, Plus, Div];
        if self.0 >= 1 << 6 {
            return None
        }
        let f1 = OPTIONS[(self.0 & (3 << 4)) >> 4];
        let f2 = OPTIONS[(self.0 & (3 << 2)) >> 2];
        let f3 = OPTIONS[(self.0 & (3 << 0)) >> 0];
        self.0 += 1;
        Some([f1, f2, f3])
    }
}

fn orders() -> [[usize; 4]; 24] {
    [
        [0, 1, 2, 3],
        [0, 1, 3, 2],
        [0, 2, 1, 3],
        [0, 2, 3, 1],
        [0, 3, 1, 2],
        [0, 3, 2, 1],
        [1, 0, 2, 3],
        [1, 0, 3, 2],
        [1, 2, 0, 3],
        [1, 2, 3, 0],
        [1, 3, 0, 2],
        [1, 3, 2, 0],
        [2, 0, 1, 3],
        [2, 0, 3, 1],
        [2, 1, 0, 3],
        [2, 1, 3, 0],
        [2, 3, 0, 1],
        [2, 3, 1, 0],
        [3, 0, 1, 2],
        [3, 0, 2, 1],
        [3, 1, 0, 2],
        [3, 1, 2, 0],
        [3, 2, 0, 1],
        [3, 2, 1, 0]
    ]
}

fn apply_order(numbers: [i32; 4], order: &[usize; 4]) -> [i32; 4] {
    [numbers[order[0]], numbers[order[1]], numbers[order[2]], numbers[order[3]]]
}
