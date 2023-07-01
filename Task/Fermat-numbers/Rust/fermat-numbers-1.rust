 struct DivisorGen {
    curr: u64,
    last: u64,
}

impl Iterator for DivisorGen {
    type Item = u64;

    fn next(&mut self) -> Option<u64> {
        self.curr += 2u64;

        if self.curr < self.last{
            None
        } else {
            Some(self.curr)
        }
    }
}

fn divisor_gen(num : u64) -> DivisorGen {
    DivisorGen { curr: 0u64, last: (num / 2u64) + 1u64 }
}

fn is_prime(num : u64) -> bool{
    if num == 2 || num == 3 {
        return true;
    } else if num % 2 == 0 || num % 3 == 0 || num <= 1{
        return false;
    }else{
        for i in divisor_gen(num){
            if num % i == 0{
                return false;
            }
        }
    }
    return true;
}


fn main() {
    let fermat_closure = |i : u32| -> u64 {2u64.pow(2u32.pow(i + 1u32))};
    let mut f_numbers : Vec<u64> = Vec::new();

    println!("First 4 Fermat numbers:");
    for i in 0..4 {
        let f = fermat_closure(i) + 1u64;
        f_numbers.push(f);
        println!("F{}: {}", i, f);
    }

    println!("Factor of the first four numbers:");
    for f in f_numbers.iter(){
        let is_prime : bool = f % 4 == 1 && is_prime(*f);
        let not_or_not = if is_prime {" "} else {" not "};
        println!("{} is{}prime", f, not_or_not);
    }
}
