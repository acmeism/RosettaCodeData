use std::env;
use std::str::FromStr;

fn add(list: &mut Vec<usize>, t: usize) {
    list.push(1 | t << 1);
}

fn show(mut t: usize, mut len: usize) {
    while len > 0 {
        len -= 1;
        print!("{}", if (t & 1) != 0 { '(' } else { ')' });
        t >>= 1;
    }
}

fn list_trees(list: &Vec<usize>, offset: &Vec<usize>, n: usize) {
    for i in offset[n]..offset[n+1] {
        show(list[i], n*2);
        println!();
    }
}

/* assemble tree from subtrees
n:   length of tree we want to make
t:   assembled parts so far
sl:  length of subtree we are looking at
pos: offset of subtree we are looking at
rem: remaining length to be put together
*/
fn assemble(list: &mut Vec<usize>, offset: &mut Vec<usize>, n: usize, t: usize, mut sl: usize, mut pos: usize, rem: usize) {
   if rem == 0 {
        add(list, t);
        return;
    }
    if sl > rem { // need smaller sub-trees
        sl = rem;
        pos = offset[sl];
    } else if pos >= offset[sl+1] {
        // used up sl-trees, try smaller ones
        sl -= 1;
        if sl == 0 {
            return;
        }
        pos = offset[sl];
    }
    assemble(list, offset, n, (t << (2*sl)) | list[pos], sl, pos, rem-sl);
    assemble(list, offset, n, t, sl, pos+1, rem);
}

fn mktrees(list: &mut Vec<usize>, offset: &mut Vec<usize>, n: usize) {
    if offset[n+1] > 0 {
        return;
    }
    if n > 0 {
        mktrees(list, offset, n - 1);
    }
    assemble(list, offset, n, 0, n-1, offset[n-1], n-1);
    offset[n+1] = list.len();
}

fn main() {
    let list: &mut Vec<usize> = &mut vec![];
    let offset: &mut Vec<usize> = &mut vec![0_usize; 32];
    offset[1] = 1_usize;
    let mut n = 5;
    let args: Vec<String> = env::args().collect();
    if args.len() == 2 {
        n = usize::from_str(args[1].as_str()).unwrap_or(5);
        n = if n <= 0 || n > 19 { 5 } else { n };
    }
    add(list, 0);
    mktrees(list, offset, n);
    println!("Number of {}-trees: {}", n, offset[n+1]-offset[n]);
    list_trees(list, offset, n);
}
