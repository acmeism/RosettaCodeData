# (entries may be real and/or complex)
def conjugate_transpose:
  map( map(conjugate) ) | transpose;

# A Hermitian matrix equals its own conjugate transpose
def is_hermitian:
  to_complex == conjugate_transpose;

# A matrix is normal if it commutes multiplicatively
# with its conjugate transpose
def is_normal:
  . as $M
  | conjugate_transpose as $H
  | matrix_multiply($H; $M) == matrix_multiply($H; $M);

# A unitary matrix (U) has its inverse equal to its conjugate transpose (T)
# i.e. U^-1 == T; NASC is I == UT == TU
def is_unitary:
  . as $M
  | conjugate_transpose as $H
  | complex_identity(length) as $I
  | approximately_equal( $I; matrix_multiply($H;$M); 1e-10)
    and approximately_equal( $I ; matrix_multiply($M;$H); 1e-10)  ;
