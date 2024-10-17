const M: usize = 0;
const C: usize = 1;
const CM: usize = 2;
const CMC: usize = 3;
static SKIP: [usize; 4] = [M, CM, CM, CMC];
static INCL: [usize; 4] = [C, C, CMC, CMC];

fn ncs(s: &Vec<i32>) -> Vec<Vec<i32>> {
    if s.len() < 3 {
        return vec![];
    }
    let mut v1 = n2([].to_vec(), s[1..].to_vec(), M);
    let mut v2 = n2([s[0]].to_vec(), s[1..].to_vec(), C);
    v1.append(&mut v2);
    return v1;
}

fn n2(ss: Vec<i32>, tail: Vec<i32>, seq: usize) -> Vec<Vec<i32>> {
    if tail.len() == 0 {
        if seq != CMC as usize {
            return vec![];
        }
        return [ss].to_vec();
    }
    let mut v1 = n2(ss.clone(), tail[1..].to_vec(), SKIP[seq]);
    let mut v2 = ss.clone();
    v2.push(tail[0]);
    let mut v3 = n2(v2, tail[1..].to_vec(), INCL[seq]);
    v1.append(&mut v3);
    return v1;
}

fn main() {
    let ss = ncs(&[1, 2, 3, 4].to_vec());
    println!("{} non-continuous subsequences:", ss.len());
    for s in ss {
        println!("  {:?}", s);
    }
}
