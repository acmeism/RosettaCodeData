use std::fmt;
use std::ops::{Add, Mul}; // Optional: for operator overloading later if desired

// --- Error Type ---
#[derive(Debug, PartialEq)]
pub enum MatrixError {
    IncompatibleDimensions(String),
    InvalidOperation(String),
    OutOfBounds(String),
}

impl fmt::Display for MatrixError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            MatrixError::IncompatibleDimensions(msg) => write!(f, "Incompatible matrix dimensions: {}", msg),
            MatrixError::InvalidOperation(msg) => write!(f, "Invalid matrix operation: {}", msg),
            MatrixError::OutOfBounds(msg) => write!(f, "Index out of bounds: {}", msg),
        }
    }
}

// Define a Result type alias for convenience
type MatrixResult<T> = Result<T, MatrixError>;

// --- Matrix Struct ---
#[derive(Debug, Clone)] // Added Debug and Clone
pub struct Matrix {
    rows: usize,
    cols: usize,
    data: Vec<Vec<f64>>,
}

impl Matrix {
    // --- Constructors ---

    /// Creates a matrix from existing 2D vector data.
    /// Validates that all inner vectors have the same length.
    pub fn from_data(data: Vec<Vec<f64>>) -> MatrixResult<Self> {
        if data.is_empty() {
            // Handle empty case: 0x0 matrix
            return Ok(Matrix { rows: 0, cols: 0, data });
        }
        let rows = data.len();
        let cols = data[0].len();
        // Validate dimensions
        if !data.iter().all(|row| row.len() == cols) {
            return Err(MatrixError::IncompatibleDimensions(
                "All rows must have the same number of columns".to_string(),
            ));
        }
        Ok(Matrix { rows, cols, data })
    }

    /// Creates a new matrix with specified dimensions, initialized to zeros.
    pub fn zeros(rows: usize, cols: usize) -> Self {
        let data = vec![vec![0.0; cols]; rows];
        Matrix { rows, cols, data }
    }

    // --- Accessors ---

    pub fn rows(&self) -> usize {
        self.rows
    }

    pub fn cols(&self) -> usize {
        self.cols
    }

    /// Gets the value at a specific row and column. Returns None if out of bounds.
    pub fn get(&self, row: usize, col: usize) -> Option<f64> {
        self.data.get(row)?.get(col).copied()
    }

     /// Gets the value at a specific row and column. Returns Error if out of bounds.
    pub fn get_entry(&self, row: usize, col: usize) -> MatrixResult<f64> {
        self.data
            .get(row)
            .and_then(|r| r.get(col))
            .copied()
            .ok_or_else(|| MatrixError::OutOfBounds(format!("Accessing ({}, {}) in {}x{} matrix", row, col, self.rows, self.cols)))
    }


    /// Sets the value at a specific row and column. Returns Error if out of bounds.
    pub fn set_entry(&mut self, row: usize, col: usize, value: f64) -> MatrixResult<()> {
         self.data
            .get_mut(row)
            .and_then(|r| r.get_mut(col))
            .map(|entry| *entry = value)
            .ok_or_else(|| MatrixError::OutOfBounds(format!("Setting ({}, {}) in {}x{} matrix", row, col, self.rows, self.cols)))
    }


    // --- Basic Matrix Operations ---

    /// Adds another matrix to this matrix.
    pub fn add(&self, other: &Matrix) -> MatrixResult<Matrix> {
        if self.rows != other.rows || self.cols != other.cols {
            return Err(MatrixError::IncompatibleDimensions(format!(
                "Cannot add {}x{} matrix to {}x{} matrix",
                self.rows, self.cols, other.rows, other.cols
            )));
        }

        let mut result_data = self.data.clone(); // Start with a copy
        for i in 0..self.rows {
            for j in 0..self.cols {
                result_data[i][j] += other.data[i][j];
            }
        }
        Ok(Matrix {
            rows: self.rows,
            cols: self.cols,
            data: result_data,
        })
    }

    /// Multiplies this matrix by another matrix.
    pub fn multiply(&self, other: &Matrix) -> MatrixResult<Matrix> {
        if self.cols != other.rows {
            return Err(MatrixError::IncompatibleDimensions(format!(
                "Cannot multiply {}x{} matrix by {}x{} matrix",
                self.rows, self.cols, other.rows, other.cols
            )));
        }

        let mut result = Matrix::zeros(self.rows, other.cols);
        for i in 0..self.rows {
            for j in 0..other.cols {
                let mut sum = 0.0;
                for k in 0..self.cols { // Note: loop limit is self.cols (or other.rows)
                    // Using direct access after checks for potentially better performance
                    // but relying on bounds being correct due to initial check.
                    // Safe access: sum += self.get_entry(i, k)? * other.get_entry(k, j)?;
                    sum += self.data[i][k] * other.data[k][j];
                }
                result.data[i][j] = sum;
                // Safe set: result.set_entry(i, j, sum)?;
            }
        }
        Ok(result)
    }

    /// Returns the transpose of this matrix.
    pub fn transpose(&self) -> Matrix {
        let mut result = Matrix::zeros(self.cols, self.rows);
        for i in 0..self.rows {
            for j in 0..self.cols {
                 // Direct access okay here as bounds are derived from self
                result.data[j][i] = self.data[i][j];
                // Safe set: result.set_entry(j, i, self.get_entry(i, j).unwrap()).unwrap(); // unwrap safe
            }
        }
        result
    }

    // --- Specific Operations (used in Householder) ---

    /// Creates a matrix where elements below/right of `index` are copied,
    /// and the top-left `index x index` part is an identity matrix.
    /// Note: In Rust, indices start from 0. The C++ code seems to imply
    /// copying starts *at* index `k`. Let's match that behavior.
    pub fn minor(&self, index: usize) -> MatrixResult<Matrix> {
         if index > self.rows || index > self.cols {
             return Err(MatrixError::OutOfBounds(format!("Index {} out of bounds for minor operation on {}x{} matrix", index, self.rows, self.cols)));
         }

        let mut result = Matrix::zeros(self.rows, self.cols);
        // Set identity part
        for i in 0..index {
           result.set_entry(i, i, 1.0)?;
        }

        // Copy the submatrix part
        for i in index..self.rows {
            for j in index..self.cols {
                result.set_entry(i, j, self.get_entry(i, j)?)?;
            }
        }
        Ok(result)
    }

    /// Extracts a column as a new column vector (Nx1 matrix).
    pub fn column(&self, index: usize) -> MatrixResult<Matrix> {
        if index >= self.cols {
             return Err(MatrixError::OutOfBounds(format!("Column index {} out of bounds for {}x{} matrix", index, self.rows, self.cols)));
        }
        let mut result = Matrix::zeros(self.rows, 1);
        for i in 0..self.rows {
           result.set_entry(i, 0, self.get_entry(i, index)?)?;
        }
        Ok(result)
    }

    /// Multiplies a *column vector* matrix by a scalar.
    pub fn scalar_multiply(&self, value: f64) -> MatrixResult<Matrix> {
        if self.cols != 1 {
             return Err(MatrixError::InvalidOperation(format!(
                "Scalar multiply requires a column vector (Nx1), but matrix is {}x{}",
                self.rows, self.cols
            )));
        }
        let mut result = Matrix::zeros(self.rows, 1);
        for i in 0..self.rows {
            result.data[i][0] = self.data[i][0] * value;
            // Safe: result.set_entry(i, 0, self.get_entry(i, 0)? * value)?;
        }
        Ok(result)
    }

     /// Normalizes a *column vector* matrix to produce a unit vector.
    pub fn unit(&self) -> MatrixResult<Matrix> {
        if self.cols != 1 {
             return Err(MatrixError::InvalidOperation(format!(
                "Unit vector requires a column vector (Nx1), but matrix is {}x{}",
                self.rows, self.cols
            )));
        }
        let mag = self.magnitude()?;
        if mag == 0.0 {
            // Avoid division by zero, return zero vector or error?
            // C++ code didn't check this, would result in NaN/Inf. Let's return error.
            return Err(MatrixError::InvalidOperation("Cannot normalize a zero vector".to_string()));
        }

        let mut result = Matrix::zeros(self.rows, 1);
        for i in 0..self.rows {
             result.data[i][0] = self.data[i][0] / mag;
             // Safe: result.set_entry(i, 0, self.get_entry(i, 0)? / mag)?;
        }
        Ok(result)
    }

    /// Calculates the L2 norm (magnitude) of a *column vector* matrix.
    pub fn magnitude(&self) -> MatrixResult<f64> {
        if self.cols != 1 {
             return Err(MatrixError::InvalidOperation(format!(
                "Magnitude requires a column vector (Nx1), but matrix is {}x{}",
                self.rows, self.cols
            )));
        }
        let mut norm_sq = 0.0;
        for i in 0..self.rows {
            let val = self.data[i][0]; // Direct access okay after check
            // Safe: let val = self.get_entry(i, 0)?;
            norm_sq += val * val;
        }
        Ok(norm_sq.sqrt())
    }

    /// Returns the number of rows for a *column vector* matrix. (Equivalent to `rows()`).
    /// Kept for closer C++ API parity, but `rows()` is more general.
    pub fn size(&self) -> MatrixResult<usize> {
         if self.cols != 1 {
             return Err(MatrixError::InvalidOperation(format!(
                "Size operation requires a column vector (Nx1), but matrix is {}x{}",
                self.rows, self.cols
            )));
        }
        Ok(self.rows)
    }

    // --- Display ---
    // Implemented via `fmt::Display` trait below
}

// --- Display Trait Implementation ---
impl fmt::Display for Matrix {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for i in 0..self.rows {
            for j in 0..self.cols {
                // Format similar to C++ setw(9), fixed, setprecision(4)
                write!(f, "{:>9.4}", self.data[i][j])?;
            }
            writeln!(f)?; // Newline after each row
        }
        Ok(()) // No extra newline like C++ display function
    }
}

// --- Helper Functions (translated from C++) ---

type MatrixPair = (Matrix, Matrix); // R, Q

/// Creates a Householder reflection matrix H = I - 2*v*v^T
/// Expects `vector` to be a column vector (Nx1).
/// Note: The C++ code assumes `vector` is already a unit vector based on usage in `householder`.
fn householder_factor(vector: &Matrix) -> MatrixResult<Matrix> {
    if vector.cols() != 1 {
         return Err(MatrixError::InvalidOperation(
            "householder_factor requires a column vector".to_string()
        ));
    }
    let size = vector.rows();
    let mut result = Matrix::zeros(size, size);

    // Calculate -2 * v * v^T
    for i in 0..size {
        for j in 0..size {
            // Using get_entry for safety, though direct access might work if performance critical
             let vi = vector.get_entry(i, 0)?;
             let vj = vector.get_entry(j, 0)?;
             result.set_entry(i, j, -2.0 * vi * vj)?;
        }
    }

    // Add identity matrix part (I - 2*v*v^T)
    for i in 0..size {
        let current_diag = result.get_entry(i, i)?;
        result.set_entry(i, i, current_diag + 1.0)?;
    }

    Ok(result)
}

/// Performs QR decomposition using Householder reflections.
/// Returns (R, Q) where A = Q*R.
fn householder(matrix: &Matrix) -> MatrixResult<MatrixPair> {
    let rows = matrix.rows();
    let cols = matrix.cols();
    let mut versions_of_q: Vec<Matrix> = Vec::new();
    let mut z = matrix.clone(); // Start with a copy of the original matrix

    let limit = std::cmp::min(cols, rows.saturating_sub(1)); // k < cols && k < rows - 1

    for k in 0..limit {
        // The C++ minor(k) creates a matrix with identity in top-left kxk
        // and the rest copied from z.
        let z1 = z.minor(k)?; // This seems intended to operate on submatrices implicitly

        // Extract the k-th column from the 'minor' matrix starting from row k
        // In C++, minor(k) zeros upper part, so column(k) effectively takes from row k down.
        // We need to replicate this specific sub-vector extraction logic.

        // --- Corrected Subvector Extraction ---
        // Create a vector x of size (rows - k) x 1 from column k of z, starting at row k.
        let sub_vec_rows = rows - k;
        let mut vector_x = Matrix::zeros(sub_vec_rows, 1);
        for i in 0..sub_vec_rows {
            vector_x.set_entry(i, 0, z1.get_entry(k + i, k)?)?; // Use z1 as per C++ code
        }
        // ---

        let mut magnitude_x = vector_x.magnitude()?;

        // Sign adjustment based on the diagonal element z[k][k]
        // Use the *original* z matrix's diagonal element for the sign check.
        if z.get_entry(k, k)? > 0.0 {
            magnitude_x = -magnitude_x;
        }

        // Create e_k vector (standard basis vector, scaled)
        // This corresponds to the first element of the sub_vector space.
        let mut vector_e = Matrix::zeros(sub_vec_rows, 1);
        if sub_vec_rows > 0 {
             vector_e.set_entry(0, 0, 1.0)?; // e_k in the subspace is (1, 0, 0...)
        }


        // Calculate Householder vector v = (x + sign(x_k)*||x||*e_k) / ||...||
        // C++: vectorE = vectorE.scalarMultiply(magnitudeX).add(vectorX).unit();
        let v_unnormalized = vector_e.scalar_multiply(magnitude_x)?.add(&vector_x)?;
        let vector_v = v_unnormalized.unit()?; // This is the normalized Householder vector v


        // Construct the full-size Householder reflector Q_k
        // The reflection calculated using vector_v (size m-k) needs to be embedded
        // into an m x m matrix: Q_k = diag(I_k, H') where H' is from vector_v.
        let mut qk = Matrix::zeros(rows, rows);
        // Identity part
        for i in 0..k {
            qk.set_entry(i,i, 1.0)?;
        }
        // Householder reflection part (H') for the submatrix
        let h_prime = householder_factor(&vector_v)?;
        for i in 0..sub_vec_rows {
            for j in 0..sub_vec_rows {
                qk.set_entry(k+i, k+j, h_prime.get_entry(i, j)?)?;
            }
        }


        versions_of_q.push(qk.clone()); // Store Q_k
        z = qk.multiply(&z)?; // Update z: z = Q_k * z
    }

    // Calculate final Q = Q_{limit-1} * ... * Q_1 * Q_0
    // Note: The C++ code seems to have Q = Q_k ... Q_0. Let's verify.
    // Standard definition is A = QR => Q^T A = R => R = Q_k ... Q_0 A
    // And Q = (Q_k ... Q_0)^T = Q_0^T ... Q_k^T = Q_0 ... Q_k (since Q_i are symmetric)
    // So the C++ multiplication order seems correct.

    if versions_of_q.is_empty() {
        // Handle case where no reflections were needed (e.g., 1xN matrix)
        // Q should be identity, R should be the original matrix
        let mut identity_q = Matrix::zeros(rows, rows);
        for i in 0..rows {
            identity_q.set_entry(i,i, 1.0)?;
        }
       return Ok((matrix.clone(), identity_q)); // R=A, Q=I
    }

    let mut final_q = versions_of_q[0].clone();
    for i in 1..versions_of_q.len() {
        // This order Q = Q_i * Q might be reversed?
        // Let's follow C++: Q = Q[i].multiply(Q);
        // If Q = Q_{k-1} ... Q_0, then multiplying Q_i * Q is Q_i * Q_{i-1} * ... * Q_0
        // This matches the required product order.
         final_q = versions_of_q[i].multiply(&final_q)?;
    }

    // Calculate R = Q * A (where Q here is Q_k...Q_0)
    let r_matrix = final_q.multiply(matrix)?;

    // The actual Q in A=QR is the transpose of the accumulated reflections product.
    // Q = (Q_k...Q_0)^T = Q_0...Q_k
    // The C++ code calculates Q = Q_k...Q_0 and then transposes it at the end.
    let q_matrix = final_q.transpose();

    // The C++ returns (R, Q). Let's match that order.
    Ok((r_matrix, q_matrix))
}


/// Solves Rx = b where R is an upper triangular matrix using back-substitution.
/// `r` is the upper triangular matrix (NxN).
/// `b` is the right-hand side column vector (Nx1).
/// Returns the solution column vector `x` (Nx1).
fn solve_upper_triangular(r: &Matrix, b: &Matrix) -> MatrixResult<Matrix> {
    if r.rows() != b.rows() || b.cols() != 1 {
         return Err(MatrixError::IncompatibleDimensions(format!(
            "R ({0}x{0}) and b ({1}x{2}) dimensions mismatch for solving Rx=b",
            r.rows(), b.rows(), b.cols()
        )));
    }

    let n = r.cols();
    let mut result = Matrix::zeros(n, 1);

    // Iterate backwards from the last row (n-1) up to 0
    for k in (0..n).rev() {
        let mut total = 0.0;
        // Calculate sum(R[k,j] * x[j]) for j from k+1 to n-1
        for j in (k + 1)..n {
            total += r.get_entry(k, j)? * result.get_entry(j, 0)?;
        }

        // Check for zero on diagonal (singular matrix)
        let r_kk = r.get_entry(k, k)?;
        if r_kk.abs() < 1e-10 { // Use tolerance for floating point
            return Err(MatrixError::InvalidOperation("Matrix R is singular or near-singular.".to_string()));
        }

        // Calculate x[k] = (b[k] - total) / R[k,k]
        let val = (b.get_entry(k, 0)? - total) / r_kk;
        result.set_entry(k, 0, val)?;
    }

    Ok(result)
}


/// Solves the least squares problem Ax = b using QR decomposition.
/// `vandermonde` corresponds to matrix A.
/// `b` is the right-hand side vector.
fn least_squares(vandermonde: &Matrix, b: &Matrix) -> MatrixResult<Matrix> {
    // Perform QR decomposition: A = QR
    let (r_matrix, q_matrix) = householder(vandermonde)?;

    // We need to solve Rx = Q^T * b
    // Our householder returns (R, Q), so Q^T is Q.transpose()
    let q_transpose = q_matrix.transpose();
    let q_transpose_b = q_transpose.multiply(b)?;

    // The system might be Ax=b where A is MxN, M > N.
    // QR decomposition gives A = QR where Q is MxM orthogonal, R is MxN upper trapezoidal.
    // Q^T A = R => Q^T (Ax) = Q^T b => R x = Q^T b
    // R = [ R' ] where R' is NxN upper triangular
    //     [ 0  ]
    // Q^T b = [ c1 ] where c1 is Nx1
    //         [ c2 ]
    // We solve R' x = c1.

    let n = vandermonde.cols(); // Number of columns in A = number of variables in x
    if r_matrix.rows() < n {
        return Err(MatrixError::InvalidOperation("R matrix has fewer rows than columns needed for solving.".to_string()));
    }

    // Extract the top NxN part of R (R')
    let mut r_prime = Matrix::zeros(n, n);
    for i in 0..n {
        for j in i..n { // Upper triangular part
            r_prime.set_entry(i, j, r_matrix.get_entry(i, j)?)?;
        }
    }

    // Extract the top N rows of Q^T * b (c1)
    let mut c1 = Matrix::zeros(n, 1);
     if q_transpose_b.rows() < n {
        return Err(MatrixError::InvalidOperation("Q^T*b vector has fewer rows than needed for solving.".to_string()));
    }
    for i in 0..n {
        c1.set_entry(i, 0, q_transpose_b.get_entry(i, 0)?)?;
    }


    // Solve the upper triangular system R' x = c1
    solve_upper_triangular(&r_prime, &c1)
}

/// Fits a polynomial of a given degree to data points (x, y).
/// `x` is a 1xN row vector of x-coordinates.
/// `y` is a 1xN row vector of y-coordinates.
/// Returns the polynomial coefficients as a column vector.
fn fit_polynomial(x: &Matrix, y: &Matrix, polynomial_degree: usize) -> MatrixResult<Matrix> {
    // Validate input dimensions
    if x.rows() != 1 || y.rows() != 1 || x.cols() != y.cols() {
         return Err(MatrixError::IncompatibleDimensions(
            "x and y must be 1xN matrices with the same N".to_string()
        ));
    }
    let num_points = x.cols();
    let num_coeffs = polynomial_degree + 1;

    // Create the Vandermonde matrix (MxN where M=num_points, N=num_coeffs)
    let mut vandermonde = Matrix::zeros(num_points, num_coeffs);
    for i in 0..num_points { // Iterate through data points (rows of Vandermonde)
        let x_val = x.get_entry(0, i)?;
        for j in 0..num_coeffs { // Iterate through powers (columns of Vandermonde)
            vandermonde.set_entry(i, j, x_val.powi(j as i32))?; // V[i, j] = x_i ^ j
        }
    }

    // The least squares function expects b as a column vector.
    // Our y is currently a row vector. Transpose it.
    let y_col = y.transpose();

    // Solve the least squares problem Vc = y
    least_squares(&vandermonde, &y_col)
}


// --- Main Function (example usage) ---
fn main() -> MatrixResult<()> {
    let data = vec![
        vec![12.0, -51.0, 4.0],
        vec![6.0, 167.0, -68.0],
        vec![-4.0, 24.0, -41.0],
        vec![-1.0, 1.0, 0.0],
        vec![2.0, 0.0, 3.0],
    ];

    // Task 1: QR Decomposition
    println!("--- Task 1: QR Decomposition ---");
    let a = Matrix::from_data(data)?;
    println!("Initial matrix A:");
    println!("{}", a);

    let (r_matrix, q_matrix) = householder(&a)?; // Returns (R, Q)

    println!("Matrix Q:");
    println!("{}", q_matrix);
    println!("Matrix R:");
    println!("{}", r_matrix);

    let result = q_matrix.multiply(&r_matrix)?;
    println!("Matrix Q * R:");
    println!("{}", result);

    // Task 2: Polynomial Fitting
    println!("--- Task 2: Polynomial Fitting ---");
    let x = Matrix::from_data(vec![vec![
        0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0,
    ]])?;
    let y = Matrix::from_data(vec![vec![
        1.0, 6.0, 17.0, 34.0, 57.0, 86.0, 121.0, 162.0, 209.0, 262.0, 321.0,
    ]])?;

    let poly_coeffs = fit_polynomial(&x, &y, 2)?; // Fit a quadratic polynomial (degree 2)
    println!("Result of fitting polynomial (coefficients c0, c1, c2):");
    println!("{}", poly_coeffs);

    // Example: Check coefficients (should be close to c0=1, c1=2, c2=3 for y = 1 + 2x + 3x^2)
    // Note: The calculated coefficients might be:
    // [ 1.0000 ]
    // [ 2.0000 ]
    // [ 3.0000 ]

    Ok(())
}
