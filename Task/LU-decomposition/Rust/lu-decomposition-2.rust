use abstalg::*;
pub struct Matrix2D<'a, F>
where
    F: Field,
{
    field: MatrixRing<F>,
    data: &'a mut Vec<<F as Domain>::Elem>,
    rows: usize,
    cols: usize,
}

impl<'a, F: Field + Clone> Matrix2D<'a, F> {
    pub fn new(field: F, data: &'a mut Vec<<F as Domain>::Elem>, rows: usize, cols: usize) -> Self {
        assert_eq!(rows * cols, data.len(), "Data does not match dimensions");
        Matrix2D {
            field: MatrixRing::<F>::new(field, rows),
            data,
            rows,
            cols,
        }
    }

    pub fn get(&self, row: usize, col: usize) -> &<F as Domain>::Elem {
        assert!(row < self.rows && col < self.cols, "Index out of bounds");
        &self.data[row * self.cols + col]
    }

    pub fn get_mut(&mut self, row: usize, col: usize) -> &mut <F as Domain>::Elem {
        assert!(row < self.rows && col < self.cols, "Index out of bounds");
        &mut self.data[row * self.cols + col]
    }

    pub fn get_row(&self, row: usize) -> Vec<<F as Domain>::Elem> {
        assert!(row < self.rows, "Row index out of bounds");
        let mut result = Vec::new();
        for col in 0..self.cols {
            result.push(self.get(row, col).clone());
        }
        result
    }

    pub fn get_col(&self, col: usize) -> Vec<<F as Domain>::Elem> {
        assert!(col < self.cols, "Column index out of bounds");
        let mut result = Vec::new();
        for row in 0..self.rows {
            result.push(self.get(row, col).clone());
        }
        result
    }

    pub fn set_row(&mut self, row: usize, new_row: Vec<<F as Domain>::Elem>) {
        assert!(row < self.rows, "Row index out of bounds");
        assert_eq!(new_row.len(), self.cols, "New row has wrong length");
        for col in 0..self.cols {
            *self.get_mut(row, col) = new_row[col].clone();
        }
    }

    pub fn set_col(&mut self, col: usize, new_col: Vec<<F as Domain>::Elem>) {
        assert!(col < self.cols, "Column index out of bounds");
        assert_eq!(new_col.len(), self.rows, "New column has wrong length");
        for row in 0..self.rows {
            *self.get_mut(row, col) = new_col[row].clone();
        }
    }

    pub fn swap_rows(&mut self, row1: usize, row2: usize) {
        assert!(
            row1 < self.rows && row2 < self.rows,
            "Row index out of bounds"
        );
        if row1 != row2 {
            for col in 0..self.cols {
                let temp = self.get(row1, col).clone();
                *self.get_mut(row1, col) = self.get(row2, col).clone();
                *self.get_mut(row2, col) = temp;
            }
        }
    }
    pub fn l_u_decomposition(&mut self) -> Result<Vec<<F as Domain>::Elem>, String>
    where
        F: Clone,
    {
        // Let base = field.base()
        let base = self.field.base().clone();
        // Let v_a = VectorAlgebra(base, cols)
        let v_a = VectorAlgebra::new(base.clone(), self.cols);
        // Let the_l_matrix = I (creates an identity matrix)
        let mut the_l_matrix: Vec<_> = self.field.int(1);
        // Let l_matrix = Matrix2D(base, the_l_matrix, rows, cols)
        let mut l_matrix = Matrix2D::new(base.clone(), &mut the_l_matrix, self.rows, self.cols);

        // For each pivot in min(rows, cols)
        for pivot in 0..std::cmp::min(self.rows, self.cols) {
            // Let pivot_row = self.get_row(pivot)
            let pivot_row = self.get_row(pivot);
            // If pivot element (pivot_row[pivot]) is zero, LU decomposition is not possible
            if base.is_zero(&pivot_row[pivot]) {
                return Err(
                    "LU decomposition without pivoting is not possible for this matrix".into(),
                );
            }
            // Let pivot_entry_inv = 1 / pivot_row[pivot]
            let pivot_entry_inv = base.inv(&pivot_row[pivot]);

            // For each row_idx in (pivot + 1) to rows
            for row_idx in (pivot + 1)..self.rows {
                // Let row = self.get_row(row_idx)
                let mut row = self.get_row(row_idx);
                // Let scale = row[pivot] * pivot_entry_inv
                let scale = base.mul(&row[pivot], &pivot_entry_inv);

                // row += -scale * pivot_row (Vector addition and scalar multiplication)
                v_a.add_assign(
                    &mut row,
                    &v_a.neg(&mul_vector(&v_a, scale.clone(), pivot_row.clone())),
                );

                // l_matrix[row_idx][pivot] = scale
                *l_matrix.get_mut(row_idx, pivot) = scale;
                // self.set_row(row_idx, row) (Sets the modified row back into the matrix)
                self.set_row(row_idx, row);
            }
        }
        // Returns the L matrix
        Ok(the_l_matrix)
    }

    pub fn p_l_u_decomposition(
        &self,
    ) -> Result<
        (
            Vec<<F as Domain>::Elem>,
            Vec<<F as Domain>::Elem>,
            Vec<<F as Domain>::Elem>,
        ),
        String,
    >
    where
        F: Clone,
    {
        let base = self.field.base().clone();
        let mut self2 = (*self.data).clone();
        let mut cloned_vector = Matrix2D::new(base.clone(), &mut self2, self.rows, self.cols);
        let mut pivot_row = 0;

        let mut the_p_matrix: Vec<_> = self.field.zero();
        let mut p_matrix = Matrix2D::new(base.clone(), &mut the_p_matrix, self.rows, self.cols);
        //let mut u_matrix = self.clone(); //Initializes the U matrix as a copy of the original matrix

        for pivot_col in 0..self.cols {
            // Find a non-zero entry in the pivot column
            let swap_row = (pivot_row..self.rows)
                .find(|&row| !base.equals(cloned_vector.get(row, pivot_col), &base.zero()));
            match swap_row {
                Some(swap_row) => {
                    // Swap rows in U and P matrices to bring the non-zero entry to the pivot position
                    cloned_vector.swap_rows(pivot_row, swap_row);
                    p_matrix.swap_rows(pivot_row, swap_row);
                    pivot_row += 1;
                }
                None => {
                    // If there are no non-zero entries in the pivot column, just proceed to the next column
                }
            }
        }

        // Set the diagonals of P to 1
        for i in 0..self.rows {
            *p_matrix.get_mut(i, i) = base.one();
        }

        // Run the LU decomposition on the permuted U matrix
        let l_u_result = cloned_vector.l_u_decomposition();

        match l_u_result {
            Ok(the_l_matrix) => Ok((the_p_matrix, the_l_matrix, cloned_vector.data.clone())),
            Err(e) => Err(e),
        }
    }
}

use std::{error::Error, fmt};
impl<'a, T> fmt::Display for Matrix2D<'a, T>
where
    <T as Domain>::Elem: fmt::Display,
    T: Field,
{
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for row in 0..self.rows {
            for col in 0..self.cols {
                write!(f, "{} ", self.get(row, col))?;
            }
            writeln!(f)?;
        }
        Ok(())
    }
}

fn mul_vector<T>(
    f: &VectorAlgebra<T>,
    a: <T as Domain>::Elem,
    d: Vec<<T as Domain>::Elem>,
) -> <VectorAlgebra<T> as Domain>::Elem
where
    T: Field,
{
    f.mul(&d, &f.diagonal(a))
}

#[cfg(test)]
mod tests {
    use super::*; // bring into scope everything from the parent module
    use abstalg::ReducedFractions;
    use abstalg::I32;

    fn test_p_l_u_decomposition(matrix: Vec<isize>, size: usize) {
        // This test assumes that the base field is rational numbers.
        // Create a test 4x4 matrix
        let (matrix, size): (Vec<isize>, usize) =
            (vec![11, 9, 24, 2, 1, 5, 2, 6, 3, 17, 18, 1, 2, 5, 7, 1], 4);
        let field = abstalg::ReducedFractions::new(abstalg::I32);
        let matrix_ring = MatrixRing::new(field.clone(), size);
        let mut matrix: Vec<_> = matrix.clone().into_iter().map(|i| field.int(i)).collect();
        let mut matrix2d = Matrix2D::new(field.clone(), &mut matrix, size, size);

        // Decompose the matrix using the p_l_u_decomposition function
        let p_l_u_decomposition_result = matrix2d.p_l_u_decomposition().unwrap();
        let (mut p_matrix, mut l_matrix, mut u_matrix) = p_l_u_decomposition_result;

        // Convert the matrices back to Matrix2D form for printing
        let p_matrix2d = Matrix2D::new(field.clone(), &mut p_matrix, size, size);
        let l_matrix2d = Matrix2D::new(field.clone(), &mut l_matrix, size, size);
        let u_matrix2d = Matrix2D::new(field.clone(), &mut u_matrix, size, size);

        println!("P={} L={} U={}", p_matrix2d, l_matrix2d, u_matrix2d,);

        // Multiply the resulting P, L, and U matrices
        let p_l = matrix_ring.mul(&p_matrix, &l_matrix);
        let mut p_l_u = matrix_ring.mul(&p_l, &u_matrix);

        //let p_l_u_2d = Matrix2D::new(field.clone(), &mut p_l_u, 4, 4);
        // Check that the product of P, L, and U is equal to the original matrix
        assert_eq!(matrix, p_l_u);
    }

    #[test]
    fn test_p_l_u_decomposition_example() {
        test_p_l_u_decomposition(vec![
            11, 9, 24, 2,
            1, 5, 2, 6,
            3, 17, 18, 1,
            2, 5, 7, 1,
        ], 4);
        test_p_l_u_decomposition(vec![
            1, 3, 5,
            2, 4, 7,
            1, 1, 0,
        ], 3);
    }
}
