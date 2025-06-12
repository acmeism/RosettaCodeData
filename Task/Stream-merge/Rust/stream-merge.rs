use std::cmp::Ordering;

fn merge2<T: Ord + Copy, F: Fn(T)>(c1: &[T], c2: &[T], action: F) {
    let mut i1 = 0;
    let mut i2 = 0;

    while i1 < c1.len() && i2 < c2.len() {
        if c1[i1] <= c2[i2] {
            action(c1[i1]);
            i1 += 1;
        } else {
            action(c2[i2]);
            i2 += 1;
        }
    }

    while i1 < c1.len() {
        action(c1[i1]);
        i1 += 1;
    }

    while i2 < c2.len() {
        action(c2[i2]);
        i2 += 1;
    }
}

fn merge_n<T: Ord + Copy, F: Fn(T)>(action: F, all: &[&[T]]) {
    let mut vit: Vec<(usize, usize)> = all.iter().map(|c| (0, c.len())).collect();

    loop {
        let mut done = true;
        let mut least: Option<usize> = None;

        for (i, &(start, end)) in vit.iter().enumerate() {
            if start < end {
                if least.is_none() {
                    least = Some(i);
                } else {
                    if let Some(l) = least {
                        if all[i][start].cmp(&all[l][vit[l].0]) == Ordering::Less {
                            least = Some(i);
                        }
                    }
                }
            }
        }

        if let Some(l) = least {
            if vit[l].0 < vit[l].1 {
                done = false;
                action(all[l][vit[l].0]);
                vit[l].0 += 1;
            }
        }

        if done {
            break;
        }
    }
}


fn display(num: i32) {
    print!("{} ", num);
}

fn main() {
    let v1 = vec![0, 3, 6];
    let v2 = vec![1, 4, 7];
    let v3 = vec![2, 5, 8];

    merge2(&v2, &v1, display);
    println!();

    merge_n(display, &[&v1]);
    println!();

    merge_n(display, &[&v3, &v2, &v1]);
    println!();
}
