fn hofq(q: &mut Vec<u32>, x : u32) -> u32 {
    let cur_len=q.len()-1;
    let i=x as usize;
    if i>cur_len {
        // extend storage
        q.reserve(i+1);
        for j in (cur_len+1)..(i+1) {
            let qj=(q[j-q[j-1] as usize]+q[j-q[j-2] as usize]) as u32;
            q.push(qj);
        }
    }
    q[i]
}

fn main() {
    let mut q_memo: Vec<u32>=vec![0,1,1];
    let mut q=|i| {hofq(&mut q_memo, i)};
    for i in 1..11 {
        println!("Q({})={}", i, q(i));
    }
    println!("Q(1000)={}", q(1000));
    let q100001=q(100_000); // precompute all
    println!("Q(100000)={}", q100000);
    let nless=(1..100_000).fold(0,|s,i|{if q(i+1)<q(i) {s+1} else {s}});
    println!("Term is less than preceding term {} times", nless);
}
