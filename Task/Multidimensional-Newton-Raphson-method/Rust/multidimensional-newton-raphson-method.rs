fn to_reduced_row_echelon_form(mut vec: Vec<Vec<f64>>) -> Vec<Vec<f64>> {
    let row_count = vec.len();
    let col_count = if row_count > 0 { vec[0].len() } else { 0 };

    let mut lead: usize = 0;
    for row in 0..row_count {
        if col_count <= lead {
            return vec;
        }
        let mut i = row;

        while vec[i][lead] == 0.0 {
            i += 1;
            if row_count == i {
                i = row;
                lead += 1;
                if col_count == lead {
                    return vec;
                }
            }
        }

        vec.swap(i, row);

        if vec[row][lead] != 0.0 {
            let divisor = vec[row][lead];
            for col in 0..col_count {
                vec[row][col] /= divisor;
            }
        }

        for k in 0..row_count {
            if k != row {
                let multiplier = vec[k][lead];
                for j in 0..col_count {
                    vec[k][j] -= vec[row][j] * multiplier;
                }
            }
        }

        lead += 1;
    }
    vec
}

fn inverse(vec: &Vec<Vec<f64>>) -> Result<Vec<Vec<f64>>, String> {
    if vec.len() != vec[0].len() {
        return Err("Not a square vector".to_string());
    }

    let size = vec.len();
    let mut augmented: Vec<Vec<f64>> = vec![vec![0.0; 2 * size]; size];

    for row in 0..size {
        for col in 0..size {
            augmented[row][col] = vec[row][col];
        }
        // Copy identity matrix to the right hand side of augmented matrix
        augmented[row][row + size] = 1.0;
    }

    let augmented = to_reduced_row_echelon_form(augmented);
    let mut result: Vec<Vec<f64>> = vec![vec![0.0; size]; size];
    // Copy inverse matrix from right hand side of augmented matrix
    for row in 0..size {
        for col in 0..size {
            result[row][col] = augmented[row][col + size];
        }
    }
    Ok(result)
}

fn multiply(one: &Vec<Vec<f64>>, two: &Vec<Vec<f64>>) -> Result<Vec<Vec<f64>>, String> {
    if one[0].len() != two.len() {
        return Err("Incompatible vector sizes".to_string());
    }

    let row_count = one.len();
    let col_count = two[0].len();
    let mut result: Vec<Vec<f64>> = vec![vec![0.0; col_count]; row_count];
    for row in 0..row_count {
        for col in 0..col_count {
            for k in 0..one[0].len() {
                result[row][col] += one[row][k] * two[k][col];
            }
        }
    }
    Ok(result)
}

fn solve(
    functions: &Vec<Box<dyn Fn(&Vec<f64>) -> f64>>,
    jacobian: &Vec<Vec<Box<dyn Fn(&Vec<f64>) -> f64>>>,
    mut values: Vec<f64>,
) -> Vec<f64> {
    let size = functions.len();
    let epsilon = 0.000_000_08;
    let max_iterations = 4;
    let mut iteration = 0;
    let mut max_change = 0.0;

    while iteration < max_iterations || max_change < epsilon {
        let mut column: Vec<Vec<f64>> = vec![vec![0.0; 1]; size];
        for i in 0..size {
            column[i][0] = functions[i](&values);
        }

        let mut jac: Vec<Vec<f64>> = vec![vec![0.0; values.len()]; size];
        for i in 0..size {
            for j in 0..size {
                jac[i][j] = jacobian[i][j](&values);
            }
        }

        let jac_inverse_result = inverse(&jac);

        let jac_inverse = match jac_inverse_result {
            Ok(val) => val,
            Err(err) => panic!("Error in inverse: {}", err),
        };

        let delta_result = multiply(&jac_inverse, &column);
        let delta = match delta_result {
            Ok(val) => val,
            Err(err) => panic!("Error in multiply: {}", err),
        };

        for i in 0..size {
            values[i] -= delta[i][0];
            if delta[i][0].abs() > max_change {
                max_change = delta[i][0].abs();
            }
        }

        iteration += 1;
    }
    values
}

fn main() {
    // Solve the two non-linear equations:
    //    y + x^2 - x - 0.5 = 0
    //    y + 5xy - x^2 = 0
    //    with initial values of x = 1.2, y = 1.2
    let functions: Vec<Box<dyn Fn(&Vec<f64>) -> f64>> = vec![
        Box::new(|a: &Vec<f64>| a[1] + a[0] * a[0] - a[0] - 0.5),
        Box::new(|a: &Vec<f64>| a[1] + 5.0 * a[0] * a[1] - a[0] * a[0]),
    ];

    let jacobian: Vec<Vec<Box<dyn Fn(&Vec<f64>) -> f64>>> = vec![
        vec![
            Box::new(|a: &Vec<f64>| 2.0 * a[0] - 1.0),
            Box::new(|_a: &Vec<f64>| 1.0),
        ],
        vec![
            Box::new(|a: &Vec<f64>| 5.0 * a[1] - 2.0 * a[0]),
            Box::new(|a: &Vec<f64>| 1.0 + 5.0 * a[0]),
        ],
    ];

    let initial_values = vec![1.2, 1.2];

    let result = solve(&functions, &jacobian, initial_values);
    println!("x = {}, y = {}", result[0], result[1]);

    // Solve the three non-linear equations:
    //  9x^2 + 36y^2 + 4z^2 - 36 = 0
    //  x^2 - 2y^2 - 20z = 0
    //  x^2 - y^2 + z^2 = 0
    //  with initial values of x = 1.0, y = 1.0 and z = 0.0
    let functions: Vec<Box<dyn Fn(&Vec<f64>) -> f64>> = vec![
        Box::new(|a: &Vec<f64>| {
            9.0 * a[0] * a[0] + 36.0 * a[1] * a[1] + 4.0 * a[2] * a[2] - 36.0
        }),
        Box::new(|a: &Vec<f64>| a[0] * a[0] - 2.0 * a[1] * a[1] - 20.0 * a[2]),
        Box::new(|a: &Vec<f64>| a[0] * a[0] - a[1] * a[1] + a[2] * a[2]),
    ];

    let jacobian: Vec<Vec<Box<dyn Fn(&Vec<f64>) -> f64>>> = vec![
        vec![
            Box::new(|a: &Vec<f64>| 18.0 * a[0]),
            Box::new(|a: &Vec<f64>| 72.0 * a[1]),
            Box::new(|a: &Vec<f64>| 8.0 * a[2]),
        ],
        vec![
            Box::new(|a: &Vec<f64>| 2.0 * a[0]),
            Box::new(|a: &Vec<f64>| -4.0 * a[1]),
            Box::new(|_a: &Vec<f64>| -20.0),
        ],
        vec![
            Box::new(|a: &Vec<f64>| 2.0 * a[0]),
            Box::new(|a: &Vec<f64>| -2.0 * a[1]),
            Box::new(|a: &Vec<f64>| 2.0 * a[2]),
        ],
    ];

    let initial_values = vec![1.0, 1.0, 0.0];

    let result = solve(&functions, &jacobian, initial_values);
    println!("x = {}, y = {}, z = {}", result[0], result[1], result[2]);
}
