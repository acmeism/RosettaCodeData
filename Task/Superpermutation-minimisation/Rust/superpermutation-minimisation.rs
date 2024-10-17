const MAX: usize = 12;

// 1! + 2! + ... + n!
fn fact_sum(n: usize) -> usize {
    let mut sum = 0_usize;
    let mut fact = 1_usize;
    let mut x = 0_usize;
    while x < n {
        x += 1;
        fact *= x;
        sum += fact;
    }
    return sum;
}

fn r(n: usize, sup: &mut Vec<u8>, pos: &mut usize, cnt: &mut Vec<usize>) -> bool {
    if n == 0 {
        return false;
    }
    let c = sup[*pos - n];
    cnt[n] -= 1;
    if cnt[n] == 0 {
        cnt[n] = n;
        if !r(n - 1, sup, pos, cnt) {
            return false;
        }
    }
    sup[*pos] = c;
    *pos += 1;
    return true;
}

fn superperm(n: usize, sup: &mut Vec<u8>, pos: &mut usize, cnt: &mut Vec<usize>) -> usize {
    *pos = n;
    let new_len = fact_sum(n);
    sup.resize(new_len, 0);
    for i in 0..=n {
        cnt[i] = i;
    }
    for i in 1..=n {
        sup[i - 1] = (i as u8) + ('0' as u8);
    }

    while r(n, sup, pos, cnt) {}
    return sup.len();
}

fn main() {
    let sup: &mut Vec<u8> = &mut [0_u8; 0].to_vec();
    let pos: &mut usize = &mut 0_usize;
    let cnt: &mut Vec<usize> = &mut [0_usize; MAX].to_vec();
    for n in 0..MAX {
        println!("superperm of {:<2} has a length of {}", n, superperm(n, sup, pos, cnt));
    }
}
