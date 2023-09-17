/*
 * g++ -O3 -Wall --std=c++11 qr_standalone.cpp -o qr_standalone
 */
#include <cstdio>
#include <cstdlib>
#include <cstring> // for memset
#include <limits>
#include <iostream>
#include <vector>

#include <math.h>

class Vector;

class Matrix {

public:
  // default constructor (don't allocate)
  Matrix() : m(0), n(0), data(nullptr) {}

  // constructor with memory allocation, initialized to zero
  Matrix(int m_, int n_) : Matrix() {
    m = m_;
    n = n_;
    allocate(m_,n_);
  }

  // copy constructor
  Matrix(const Matrix& mat) : Matrix(mat.m,mat.n) {

    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
	(*this)(i,j) = mat(i,j);
  }

  // constructor from array
  template<int rows, int cols>
  Matrix(double (&a)[rows][cols]) : Matrix(rows,cols) {

    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
	(*this)(i,j) = a[i][j];
  }

  // destructor
  ~Matrix() {
    deallocate();
  }


  // access data operators
  double& operator() (int i, int j) {
    return data[i+m*j]; }
  double  operator() (int i, int j) const {
    return data[i+m*j]; }

  // operator assignment
  Matrix& operator=(const Matrix& source) {

    // self-assignment check
    if (this != &source) {
      if ( (m*n) != (source.m * source.n) ) { // storage cannot be reused
	allocate(source.m,source.n);          // re-allocate storage
      }
      // storage can be used, copy data
      std::copy(source.data, source.data + source.m*source.n, data);
    }
    return *this;
  }

  // compute minor
  void compute_minor(const Matrix& mat, int d) {

    allocate(mat.m, mat.n);

    for (int i = 0; i < d; i++)
      (*this)(i,i) = 1.0;
    for (int i = d; i < mat.m; i++)
      for (int j = d; j < mat.n; j++)
	(*this)(i,j) = mat(i,j);

  }

  // Matrix multiplication
  // c = a * b
  // c will be re-allocated here
  void mult(const Matrix& a, const Matrix& b) {

    if (a.n != b.m) {
      std::cerr << "Matrix multiplication not possible, sizes don't match !\n";
      return;
    }

    // reallocate ourself if necessary i.e. current Matrix has not valid sizes
    if (a.m != m or b.n != n)
      allocate(a.m, b.n);

    memset(data,0,m*n*sizeof(double));

    for (int i = 0; i < a.m; i++)
      for (int j = 0; j < b.n; j++)
	for (int k = 0; k < a.n; k++)
	  (*this)(i,j) += a(i,k) * b(k,j);

  }

  void transpose() {
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < i; j++) {
	double t = (*this)(i,j);
	(*this)(i,j) = (*this)(j,i);
	(*this)(j,i) = t;
      }
    }
  }

  // take c-th column of m, put in v
  void extract_column(Vector& v, int c);

  // memory allocation
  void allocate(int m_, int n_) {

    // if already allocated, memory is freed
    deallocate();

    // new sizes
    m = m_;
    n = n_;

    data = new double[m_*n_];
    memset(data,0,m_*n_*sizeof(double));

  } // allocate

  // memory free
  void deallocate() {

    if (data)
      delete[] data;

    data = nullptr;

  }

  int m, n;

private:
  double* data;

}; // struct Matrix

// column vector
class Vector {

public:
  // default constructor (don't allocate)
  Vector() : size(0), data(nullptr) {}

  // constructor with memory allocation, initialized to zero
  Vector(int size_) : Vector() {
    size = size_;
    allocate(size_);
  }

  // destructor
  ~Vector() {
    deallocate();
  }

  // access data operators
  double& operator() (int i) {
    return data[i]; }
  double  operator() (int i) const {
    return data[i]; }

  // operator assignment
  Vector& operator=(const Vector& source) {

    // self-assignment check
    if (this != &source) {
      if ( size != (source.size) ) {   // storage cannot be reused
	allocate(source.size);         // re-allocate storage
      }
      // storage can be used, copy data
      std::copy(source.data, source.data + source.size, data);
    }
    return *this;
  }

  // memory allocation
  void allocate(int size_) {

    deallocate();

    // new sizes
    size = size_;

    data = new double[size_];
    memset(data,0,size_*sizeof(double));

  } // allocate

  // memory free
  void deallocate() {

    if (data)
      delete[] data;

    data = nullptr;

  }

  //   ||x||
  double norm() {
    double sum = 0;
    for (int i = 0; i < size; i++) sum += (*this)(i) * (*this)(i);
    return sqrt(sum);
  }

  // divide data by factor
  void rescale(double factor) {
    for (int i = 0; i < size; i++) (*this)(i) /= factor;
  }

  void rescale_unit() {
    double factor = norm();
    rescale(factor);
  }

  int size;

private:
  double* data;

}; // class Vector

// c = a + b * s
void vmadd(const Vector& a, const Vector& b, double s, Vector& c)
{
  if (c.size != a.size or c.size != b.size) {
    std::cerr << "[vmadd]: vector sizes don't match\n";
    return;
  }

  for (int i = 0; i < c.size; i++)
    c(i) = a(i) + s * b(i);
}

// mat = I - 2*v*v^T
// !!! m is allocated here !!!
void compute_householder_factor(Matrix& mat, const Vector& v)
{

  int n = v.size;
  mat.allocate(n,n);
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      mat(i,j) = -2 *  v(i) * v(j);
  for (int i = 0; i < n; i++)
    mat(i,i) += 1;
}

// take c-th column of a matrix, put results in Vector v
void Matrix::extract_column(Vector& v, int c) {
  if (m != v.size) {
    std::cerr << "[Matrix::extract_column]: Matrix and Vector sizes don't match\n";
    return;
  }

  for (int i = 0; i < m; i++)
    v(i) = (*this)(i,c);
}

void matrix_show(const Matrix&  m, const std::string& str="")
{
  std::cout << str << "\n";
  for(int i = 0; i < m.m; i++) {
    for (int j = 0; j < m.n; j++) {
      printf(" %8.3f", m(i,j));
    }
    printf("\n");
  }
  printf("\n");
}

// L2-norm ||A-B||^2
double matrix_compare(const Matrix& A, const Matrix& B) {
  // matrices must have same size
  if (A.m != B.m or  A.n != B.n)
    return std::numeric_limits<double>::max();

  double res=0;
  for(int i = 0; i < A.m; i++) {
    for (int j = 0; j < A.n; j++) {
      res += (A(i,j)-B(i,j)) * (A(i,j)-B(i,j));
    }
  }

  res /= A.m*A.n;
  return res;
}

void householder(Matrix& mat,
		 Matrix& R,
		 Matrix& Q)
{

  int m = mat.m;
  int n = mat.n;

  // array of factor Q1, Q2, ... Qm
  std::vector<Matrix> qv(m);

  // temp array
  Matrix z(mat);
  Matrix z1;

  for (int k = 0; k < n && k < m - 1; k++) {

    Vector e(m), x(m);
    double a;

    // compute minor
    z1.compute_minor(z, k);

    // extract k-th column into x
    z1.extract_column(x, k);

    a = x.norm();
    if (mat(k,k) > 0) a = -a;

    for (int i = 0; i < e.size; i++)
      e(i) = (i == k) ? 1 : 0;

    // e = x + a*e
    vmadd(x, e, a, e);

    // e = e / ||e||
    e.rescale_unit();

    // qv[k] = I - 2 *e*e^T
    compute_householder_factor(qv[k], e);

    // z = qv[k] * z1
    z.mult(qv[k], z1);

  }

  Q = qv[0];

  // after this loop, we will obtain Q (up to a transpose operation)
  for (int i = 1; i < n && i < m - 1; i++) {

    z1.mult(qv[i], Q);
    Q = z1;

  }

  R.mult(Q, mat);
  Q.transpose();
}

double in[][3] = {
  { 12, -51,   4},
  {  6, 167, -68},
  { -4,  24, -41},
  { -1,   1,   0},
  {  2,   0,   3},
};

int main()
{
  Matrix A(in);
  Matrix Q, R;

  matrix_show(A,"A");

  // compute QR decompostion
  householder(A, R, Q);

  matrix_show(Q,"Q");
  matrix_show(R,"R");

  // compare Q*R to the original matrix A
  Matrix A_check;
  A_check.mult(Q, R);

  // compute L2 norm ||A-A_check||^2
  double l2 = matrix_compare(A,A_check);

  // display Q*R
  matrix_show(A_check, l2 < 1e-12 ? "A == Q * R ? yes" : "A == Q * R ? no");

  return EXIT_SUCCESS;
}
