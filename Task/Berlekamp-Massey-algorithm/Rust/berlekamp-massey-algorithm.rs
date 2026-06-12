use std::fmt;

pub struct BerlekampMassey {
    source: Vec<i32>,
    modulus: i32,
}

impl BerlekampMassey {
    pub fn new(source: Vec<i32>, modulus: i32) -> Self {
        BerlekampMassey { source, modulus }
    }

    pub fn compute_coefficients(&self) -> Vec<i32> {
        let mut result = Vec::new();
        let mut previous_result = Vec::new();
        let mut fail_index = -1i32;

        for i in 0..self.source.len() {
            let mut delta = self.source[i];
            for j in 1..=result.len() {
                delta -= result[j - 1] * self.source[i - j];
            }

            if delta == 0 {
                continue;
            }

            if fail_index == -1 {
                result = vec![0; i + 1];
                fail_index = i as i32;
            } else {
                let mut previous_result_copy = vec![1];
                for term in &previous_result {
                    previous_result_copy.push(-term);
                }

                let mut term_fail_index_plus_one = 0;
                for j in 1..=previous_result_copy.len() {
                    term_fail_index_plus_one += previous_result_copy[j - 1] *
                        self.source[(fail_index + 1) as usize - j];
                }

                let coeff = delta / term_fail_index_plus_one;
                for k in 0..previous_result_copy.len() {
                    previous_result_copy[k] *= coeff;
                }

                for _ in 0..(i as i32 - fail_index - 1) {
                    previous_result_copy.insert(0, 0);
                }

                let result_copy = result.clone();
                while result.len() < previous_result_copy.len() {
                    result.push(0);
                }

                for j in 0..previous_result_copy.len() {
                    result[j] += previous_result_copy[j];
                }

                if i as i32 - result_copy.len() as i32 > fail_index - previous_result.len() as i32 {
                    previous_result = result_copy;
                    fail_index = i as i32;
                }
            }
        }
        result
    }

    pub fn compute_term(&self, bm_coeffs: &[i32], index: usize) -> i32 {
        if bm_coeffs.is_empty() {
            return 0;
        }

        if index < self.source.len() {
            return (self.source[index] + self.modulus) % self.modulus;
        }

        let mut coeffs = vec![self.modulus - 1];
        coeffs.extend_from_slice(bm_coeffs);

        let bm_coeffs_size = bm_coeffs.len();
        let mut f = vec![0; bm_coeffs_size];
        let mut g = vec![0; bm_coeffs_size];

        f[0] = 1;

        if bm_coeffs_size == 1 {
            g[0] = coeffs[1];
        } else {
            g[1] = 1;
        }

        let mut power = index - 1;
        while power > 0 {
            if (power & 1) == 1 {
                f = self.polynomial_multiply(&f, &g, bm_coeffs_size, &coeffs);
            }
            g = self.polynomial_multiply(&g, &g, bm_coeffs_size, &coeffs);
            power >>= 1;
        }

        let mut result = 0;
        for i in 0..bm_coeffs_size {
            if i + 1 < self.source.len() {
                result = (result + self.source[i + 1] * f[i]) % self.modulus;
            }
        }
        (result + self.modulus) % self.modulus
    }

    pub fn polynomial(&self, bm_coeffs: &[i32]) -> String {
        let degree = bm_coeffs.len() - 1;
        if degree == 0 {
            return bm_coeffs[0].to_string();
        }

        let mut text = String::new();
        for i in (0..=degree).rev() {
            let coeff = bm_coeffs[i];
            if coeff == 0 {
                continue;
            }

            let sign = if coeff < 0 && i == degree {
                "-"
            } else if coeff < 0 {
                " - "
            } else if i < degree {
                " + "
            } else {
                ""
            };
            text.push_str(sign);

            let coeff_abs = coeff.abs();
            if coeff_abs > 1 {
                text.push_str(&coeff_abs.to_string());
            }

            let term = if i > 1 {
                format!("x^{}", i)
            } else if i == 1 {
                "x".to_string()
            } else if coeff_abs == 1 {
                "1".to_string()
            } else {
                String::new()
            };
            text.push_str(&term);
        }
        text
    }

    fn polynomial_multiply(&self, a: &[i32], b: &[i32], degree: usize, coeffs: &[i32]) -> Vec<i32> {
        let mut result = vec![0; 2 * degree];

        for i in 0..degree {
            if a[i] == 0 {
                continue;
            }
            for j in 0..degree {
                result[i + j] = (result[i + j] + a[i] * b[j]) % self.modulus;
            }
        }

        for i in (degree..2 * degree).rev() {
            if result[i] == 0 {
                continue;
            }

            let term = result[i];
            result[i] = 0;

            for j in 0..=degree {
                let index = i - j;
                if index < result.len() {
                    result[index] = (result[index] + term * coeffs[j]) % self.modulus;
                }
            }
        }
        result[0..degree].to_vec()
    }
}

fn main() {
    let source = vec![0, 1, 1, 2, 3, 5, 8, 13, 21];
    let bm = BerlekampMassey::new(source, 100);
    let bm_coeffs = bm.compute_coefficients();

    println!("Berlekamp-Massey coefficients: [{:?}] (lowest to highest degree)",
             bm_coeffs.iter().map(|x| x.to_string()).collect::<Vec<_>>().join(", "));
    println!("The connection polynomial is {} having degree {}\n",
             bm.polynomial(&bm_coeffs), bm_coeffs.len() - 1);

    println!("Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:");
    // Result can be checked on www.oeis.net, A000045
    let indices = [35, 36, 37, 38, 39, 40];
    let terms: Vec<String> = indices.iter()
        .map(|&n| bm.compute_term(&bm_coeffs, n).to_string())
        .collect();
    println!("{}", terms.join(" "));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fibonacci_sequence() {
        let source = vec![0, 1, 1, 2, 3, 5, 8, 13, 21];
        let bm = BerlekampMassey::new(source, 100);
        let coeffs = bm.compute_coefficients();

        // Test computing some terms
        assert_eq!(bm.compute_term(&coeffs, 9), 34);
        assert_eq!(bm.compute_term(&coeffs, 10), 55);
    }

    #[test]
    fn test_polynomial_format() {
        let source = vec![0, 1, 1, 2, 3, 5, 8, 13, 21];
        let bm = BerlekampMassey::new(source, 100);
        let coeffs = bm.compute_coefficients();
        let poly = bm.polynomial(&coeffs);

        // Should contain x terms for linear recurrence
        assert!(poly.contains("x"));
    }
}
