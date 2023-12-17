#include <iostream>
#include <iomanip>
#include <gsl/gsl_linalg.h>

void gsl_matrix_print(const gsl_matrix *M) {
	auto rows = M->size1;
	auto cols = M->size2;
	std::cout.precision(10);
	std::cout.setf(std::ios::fixed);
	for (auto i = 0; i < rows; i++) {
		std::cout << "|";
		for (auto j = 0; j < cols; j++) {
			std::cout << gsl_matrix_get(M, i, j) << "  ";
		}
		std::cout << "|" << std::endl;
	}
	std::cout << std::endl;
}

int main(int argc, char** argv) {
	double a[] = {3, 0, 4, 5};
	auto A = gsl_matrix_view_array(a, 2, 2);
	auto *V = gsl_matrix_alloc(2, 2);
	auto *S = gsl_vector_alloc(2);
	auto *work = gsl_vector_alloc(2);

	gsl_linalg_SV_decomp(&A.matrix, V, S, work);
	double s[] = {S->data[0], 0.0, 0.0, S->data[1]};
	auto SM = gsl_matrix_view_array(s, 2, 2);
	std::cout << "U:" << std::endl;
	gsl_matrix_print(&A.matrix);

	std::cout << "Sigma:" << std::endl;
    gsl_matrix_print(&SM.matrix);

	std::cout << "V:" << std::endl;
    gsl_matrix_print(V);

	gsl_matrix_free(V);
	gsl_vector_free(S);
	gsl_vector_free(work);
	return 0;
}
