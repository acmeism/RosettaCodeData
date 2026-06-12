use libm::lgamma; // For the lgamma function (log gamma)
use std::error::Error;

// Calculates the arithmetic mean of a slice of f64 values.
// Returns 0.0 if the slice is empty.
fn mean(data: &[f64]) -> f64 {
    let n = data.len();
    if n == 0 {
        return 0.0;
    }
    let sum: f64 = data.iter().sum();
    sum / (n as f64)
}

// Calculates the sample variance (uses n-1 denominator).
// Returns an error if the slice has fewer than 2 elements.
fn sample_variance(data: &[f64]) -> Result<f64, String> {
    let size = data.len();
    if size < 2 {
        return Err("Vector must have at least 2 elements".to_string());
    }

    let average = mean(data);
    let mut sum_squares = 0.0;
    for &element in data {
        sum_squares += (element - average).powi(2); // Use powi(2) for squaring
    }
    Ok(sum_squares / ((size - 1) as f64))
}

// Calculates the Welch-Satterthwaite degrees of freedom.
// Propagates errors from sample_variance.
fn degrees_of_freedom(one: &[f64], two: &[f64]) -> Result<f64, String> {
    let sv1 = sample_variance(one)?;
    let sv2 = sample_variance(two)?;
    let n1 = one.len() as f64;
    let n2 = two.len() as f64;

    // Ensure sample sizes are valid (already checked by sample_variance)
    // n1 and n2 will be >= 2.0 here

    let term1 = sv1 / n1;
    let term2 = sv2 / n2;

    let numer = (term1 + term2).powi(2);
    let denom_part1 = sv1.powi(2) / (n1.powi(2) * (n1 - 1.0));
    let denom_part2 = sv2.powi(2) / (n2.powi(2) * (n2 - 1.0));
    let denom = denom_part1 + denom_part2;

    if denom == 0.0 {
        // This might happen if both variances are effectively zero.
        // The interpretation depends on the context, could be infinite DoF or undefined.
        // Returning an error might be safer than Inf/NaN.
        return Err("Denominator in degrees_of_freedom calculation is zero".to_string());
    }
    Ok(numer / denom)
}

// Calculates Welch's t-statistic.
// Propagates errors from sample_variance.
fn welch(one: &[f64], two: &[f64]) -> Result<f64, String> {
    let sv1 = sample_variance(one)?;
    let sv2 = sample_variance(two)?;
    let n1 = one.len() as f64;
    let n2 = two.len() as f64;
    let mean1 = mean(one);
    let mean2 = mean(two);

    let temp = sv1 / n1 + sv2 / n2;

    if temp < 0.0 {
        // Should not happen with non-negative variances
        return Err(format!("Negative variance sum encountered: {}", temp));
    }
    if temp == 0.0 {
        // If variances are both zero, means might still differ.
        // C++ would produce Inf or NaN depending on the means.
        // Let's return NaN to indicate an undefined statistic in this case.
        if mean1 == mean2 {
           return Ok(0.0); // 0 / 0 case -> technically undefined, but often treated as 0 or 1 for p-value
        } else {
           return Ok(f64::NAN); // non-zero / 0 case
        }
    }

    Ok((mean1 - mean2) / temp.sqrt())
}

// Numerical integration using Simpson's rule.
fn simpson(a: f64, b: f64, n: u32, func: impl Fn(f64) -> f64) -> f64 {
    if n == 0 { return 0.0; } // Avoid division by zero if n=0
    let h = (b - a) / (n as f64);
    let mut sum = 0.0;
    for i in 0..n {
        let x = a + (i as f64) * h;
        // Calculate sum using Simpson's 1/3 rule component for the interval [x, x+h]
        sum += (func(x) + 4.0 * func(x + h / 2.0) + func(x + h)) / 6.0;
    }
    sum * h
}

// Calculates the two-tailed p-value using Welch's t-test components
// and Simpson's rule for the regularized incomplete beta function.
fn p2_tail(one: &[f64], two: &[f64]) -> Result<f64, String> {
    let dof = degrees_of_freedom(one, two)?;
    let welchs_t = welch(one, two)?; // Get Welch's t-statistic

    // Handle potential NaN from welch function
    if welchs_t.is_nan() {
         return Err("Welch t-statistic is NaN (likely due to zero variance)".to_string());
    }

    // Ensure degrees of freedom is positive for lgamma
    if dof <= 0.0 {
        return Err(format!("Degrees of freedom must be positive, got {}", dof));
    }

    // Calculate the factor related to the Beta function using log-gamma for numerical stability
    // gamm = Gamma(dof/2) * Gamma(0.5) / Gamma(dof/2 + 0.5)
    // Note: Using unsafe because lgamma has preconditions (arg > 0), which we checked.
    let gamm =  {
        (lgamma(dof / 2.0) + lgamma(0.5) - lgamma(dof / 2.0 + 0.5)).exp()
    };

     // Check if gamm is finite and non-zero
    if !gamm.is_finite() || gamm == 0.0 {
        return Err(format!("Gamma factor calculation resulted in invalid value: {}", gamm));
    }


    // Upper limit for the integration related to the regularized incomplete beta function
    // This corresponds to z = nu / (t^2 + nu)
    let b = dof / (welchs_t.powi(2) + dof);

    // Ensure b is within [0, 1] range (it should be mathematically)
    // Clamping might hide upstream issues, but can prevent downstream errors.
    let b_clamped = b.clamp(0.0, 1.0);
     if (b - b_clamped).abs() > 1e-9 {
         // Warn or error if clamping was significant? Let's proceed for now.
         // eprintln!("Warning: integration limit b={} was outside [0, 1]", b);
     }


    // The integrand for the incomplete Beta function B(x; a, b) with a=dof/2, b=0.5
    // Integrand = r^(a-1) * (1-r)^(b-1) = r^(dof/2 - 1) * (1-r)^(-0.5)
    let dof_div_2 = dof / 2.0;
    let func = |r: f64| -> f64 {
        // Handle potential singularities at r=0 (if dof < 2) and r=1
        if r <= 0.0 {
            if dof_div_2 > 1.0 { return 0.0; } // r^(positive) -> 0
            if (dof_div_2 - 1.0).abs() < 1e-12 { return 1.0 / (1.0 - r).sqrt(); } // r^0 case
            else { return f64::INFINITY; } // r^(negative) -> inf
        }
        if r >= 1.0 {
            return f64::INFINITY; // (1-r)^(-0.5) -> inf
        }

        // Use powf for potentially fractional exponent
        r.powf(dof_div_2 - 1.0) / (1.0 - r).sqrt()
    };

    let n_simpson = 10_000; // Number of intervals for Simpson's rule

    // Calculate the integral I_b(dof/2, 0.5) using Simpson's rule
    // This value represents the two-tailed p-value for Welch's t-test.
    let integral = simpson(0.0, b_clamped, n_simpson, func);

     // Check if integral is finite
    if !integral.is_finite() {
        // Simpson's rule might struggle with endpoint singularities.
        // A dedicated library function for regularized incomplete beta is more robust.
        // For this translation, we return an error if Simpson gives non-finite result.
        return Err(format!(
            "Simpson integration resulted in non-finite value: {}. Check for singularities near r=0 (if DoF<2) or r=1.",
             integral
        ));
    }


    // The result of the Simpson integration divided by 'gamm' gives the
    // regularized incomplete beta function I_b(dof/2, 0.5), which is the p-value.
    let p_value = integral / gamm;

    // Clamp result to [0, 1] as it's a probability
    Ok(p_value.clamp(0.0, 1.0))
}

fn main() -> Result<(), Box<dyn Error>> {
    // Define data vectors using vec! macro
    let vec1: Vec<f64> = vec![ 27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6, 23.1, 19.6, 19.0, 21.7, 21.4 ];
	let vec2: Vec<f64> = vec![ 27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2, 21.9, 22.1, 22.9, 20.5, 24.4 ];
	let vec3: Vec<f64> = vec![ 17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8 ];
	let vec4: Vec<f64> = vec![ 21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8, 20.7, 21.7, 21.5, 22.5, 23.6, 21.5, 22.5, 23.5, 21.5, 21.8 ];
	let vec5: Vec<f64> = vec![ 19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0 ];
	let vec6: Vec<f64> = vec![ 28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7, 23.2, 17.5, 20.6, 18.0, 23.9, 21.6, 24.3, 20.4, 24.0, 13.2 ];
	let vec7: Vec<f64> = vec![ 30.02, 29.99, 30.11, 29.97, 30.01, 29.99 ];
	let vec8: Vec<f64> = vec![ 29.89, 29.93, 29.72, 29.98, 30.02, 29.98 ];
	let vec_x: Vec<f64> = vec![ 3.0, 4.0, 1.0, 2.1 ];
	let vec_y: Vec<f64> = vec![ 490.2, 340.0, 433.9 ];

    // Calculate and print p-values with fixed precision
    // Using expect for simplicity; real code might use match or if let for error handling
    println!("{:.6}", p2_tail(&vec1, &vec2).map_err(|e| format!("vec1/vec2 failed: {}", e))?);
    println!("{:.6}", p2_tail(&vec3, &vec4).map_err(|e| format!("vec3/vec4 failed: {}", e))?);
    println!("{:.6}", p2_tail(&vec5, &vec6).map_err(|e| format!("vec5/vec6 failed: {}", e))?);
    println!("{:.6}", p2_tail(&vec7, &vec8).map_err(|e| format!("vec7/vec8 failed: {}", e))?);
    println!("{:.6}", p2_tail(&vec_x, &vec_y).map_err(|e| format!("vecX/vecY failed: {}", e))?);

    Ok(()) // Indicate successful execution
}
</syntaxhighlight >
{{out}}
<pre>
0.021378
0.148842
0.035972
0.090773
0.010751
</pre>


