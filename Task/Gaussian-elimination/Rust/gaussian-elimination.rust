// using a Vec<f32> might be a better idea
// for now, let us create a fixed size array
// of size:
const SIZE: usize = 6;

pub fn eliminate(mut system: [[f32; SIZE+1]; SIZE]) -> Option<Vec<f32>> {
    // produce the row reduced echelon form
    //
    // for every row...
    for i in 0..SIZE-1 {
        // for every column in that row...
        for j in i..SIZE-1 {
            if system[i][i] == 0f32 {
                continue;
            } else {
                // reduce every element under that element to 0
                let factor = system[j + 1][i] as f32 / system[i][i] as f32;
                for k in i..SIZE+1 {
                    // potential optimization: set every element to zero, instead of subtracting
                    // i think subtraction helps showcase the process better
                    system[j + 1][k] -= factor * system[i][k] as f32;
                }
            }
        }
    }

    // produce gaussian eliminated array
    //
    // the process follows a similar pattern
    // but this one reduces the upper triangular
    // elements
    for i in (1..SIZE).rev() {
        if system[i][i] == 0f32 {
            continue;
        } else {
            for j in (1..i+1).rev() {
                let factor = system[j - 1][i] as f32 / system[i][i] as f32;
                for k in (0..SIZE+1).rev() {
                    system[j - 1][k] -= factor * system[i][k] as f32;
                }
            }
        }
    }

    // produce solutions through back substitution
    let mut solutions: Vec<f32> = vec![];
    for i in 0..SIZE {
        if system[i][i] == 0f32 {
            return None;
        }
        else {
            system[i][SIZE] /= system[i][i] as f32;
            system[i][i] = 1f32;
            println!("X{} = {}", i + 1, system[i][SIZE]);
            solutions.push(system[i][SIZE])
        }
    }
    return Some(solutions);
}

#[cfg(test)]
mod tests {
    use super::*;
    // sample run of the program
    #[test]
    fn eliminate_seven_by_six() {
        let system: [[f32; SIZE +1]; SIZE] = [
            [1.00 , 0.00 , 0.00 , 0.00  , 0.00  , 0.00   , -0.01 ] ,
            [1.00 , 0.63 , 0.39 , 0.25  , 0.16  , 0.10   , 0.61  ] ,
            [1.00 , 1.26 , 1.58 , 1.98  , 2.49  , 3.13   , 0.91  ] ,
            [1.00 , 1.88 , 3.55 , 6.70  , 12.62 , 23.80  , 0.99  ] ,
            [1.00 , 2.51 , 6.32 , 15.88 , 39.90 , 100.28 , 0.60  ] ,
            [1.00 , 3.14 , 9.87 , 31.01 , 97.41 , 306.02 , 0.02  ]
        ] ;
        let solutions = eliminate(system).unwrap();
        assert_eq!(6, solutions.len());
        let assert_solns = vec![-0.01, 1.60278, -1.61320, 1.24549, -0.49098, 0.06576];
        for (ans, key) in solutions.iter().zip(assert_solns.iter()) {
            if (ans - key).abs() > 1E-4 { panic!("Test Failed!") }
        }
    }
}
