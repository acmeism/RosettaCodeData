fn read_numbers<T>() -> Vec<T>
where T: std::str::FromStr {
    use std::io::Write;
    std::io::stdout().flush().unwrap();

    let mut line = String::new();
    std::io::stdin().read_line(&mut line).unwrap();
    line.split(" ").map(|word| word.trim().parse::<T>().ok().unwrap()).collect()
}

fn main() {
    print!("Enter the number of resources: ");
    let r = read_numbers()[0];

    print!("Enter the number of processes: ");
    let p = read_numbers()[0];
    let mut running = vec![true; p];
    let mut count = p;

    print!("Enter the {}-item claim vector: ", r);
    let max_res = read_numbers::<u32>();

    println!("Enter the {}-line {}-column allocated-resource table:", p, r);
    let mut curr = vec![vec![0; 0]; p];
    for i in 0..p {
        curr[i] = read_numbers::<u32>();
    }

    println!("Enter the {}-line {}-column maximum-claim table:", p, r);
    let mut max_claim = vec![vec![0; 0]; p];
    for i in 0..p {
        max_claim[i] = read_numbers::<u32>();
    }

    print!("The claim vector is: ");
    for i in 0..r {
        print!("{} ", max_res[i]);
    }
    println!();

    println!("The allocated resources table is:");
    for i in 0..p {
        for j in 0..r {
            print!("\t{}", curr[i][j]);
        }
        println!();
    }

    println!("The maximum claims table is:");
    for i in 0..p {
        for j in 0..r {
            print!("\t{}", max_claim[i][j]);
        }
        println!();
    }

    let mut alloc = vec![0; r];
    for i in 0..p {
        for j in 0..r {
            alloc[j] += curr[i][j];
        }
    }

    print!("The allocated resources are: ");
    for i in 0..r {
        print!("{} ", alloc[i]);
    }
    println!();
    let mut avl = vec![0; r];
    for i in 0..r {
        avl[i] = max_res[i] - alloc[i];
    }

    print!("The available resources are: ");
    for i in 0..r {
        print!("{} ", avl[i]);
    }
    println!();

    while count != 0 {
        let mut safe = false;
        for i in 0..p {
            if running[i] {
                let mut exec = true;
                for j in 0..r {
                    if max_claim[i][j] - curr[i][j] > avl[j] {
                        exec = false;
                        break;
                    }
                }

                if exec {
                    println!("Process {} is executing.", i + 1);
                    running[i] = false;
                    count -= 1;
                    safe = true;
                    for j in 0..r {
                        avl[j] += curr[i][j];
                    }
                    break;
                }
            }
        }

        if safe {
            println!("The process is in safe state.");
        }
        else {
            println!("The processes are in unsafe state.");
            break;
        }

        print!("The available vector is: ");
        for i in 0..r {
            print!("{} ", avl[i]);
        }
        println!();
    }
}
