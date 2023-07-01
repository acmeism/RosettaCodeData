#include <stdio.h>//printf
#include <stdlib.h>//qsort
#include <math.h>//fabs
#include <stdbool.h>//bool data type
#include <strings.h>//strcasecmp
#include <assert.h>//assert, necessary for random integer selection

unsigned int * seq_len(const unsigned int START, const unsigned int END) {
//named after R function of same name, but simpler function
	unsigned start = (unsigned)START;
	unsigned end = (unsigned)END;
	if (START == END) {
		unsigned int *restrict sequence = malloc( (end+1) * sizeof(unsigned int));
		if (sequence == NULL) {
			printf("malloc failed at %s line %u\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
		}
		for (unsigned i = 0; i < end; i++) {
			sequence[i] = i+1;
		}
		return sequence;
	}
	if (START > END) {
		end = (unsigned)START;
		start = (unsigned)END;
	}
	const unsigned LENGTH = end - start ;
	unsigned int *restrict sequence = malloc( (1+LENGTH) * sizeof(unsigned int));
	if (sequence == NULL) {
		printf("malloc failed at %s line %u\n", __FILE__, __LINE__);
		perror("");
		exit(EXIT_FAILURE);
	}
	if (START < END) {
		for (unsigned index = 0; index <= LENGTH; index++) {
			sequence[index] = start + index;
		}
	} else {
		for (unsigned index = 0; index <= LENGTH; index++) {
			sequence[index] = end - index;
		}
	}
	return sequence;
}

//modified from https://phoxis.org/2012/07/12/get-sorted-index-orderting-of-an-array/

double *restrict base_arr = NULL;

static int compar_increase (const void *restrict a, const void *restrict b) {
	int aa = *((int *restrict ) a), bb = *((int *restrict) b);
	if (base_arr[aa] < base_arr[bb]) {
		return 1;
	} else if (base_arr[aa] == base_arr[bb]) {
		return 0;
	} else {
		return -1;
	}
}

static int compar_decrease (const void *restrict a, const void *restrict b) {
	int aa = *((int *restrict ) a), bb = *((int *restrict) b);
	if (base_arr[aa] < base_arr[bb]) {
		return -1;
	} else if (base_arr[aa] == base_arr[bb]) {
		return 0;
	} else {
		return 1;
	}
}

unsigned int * order (const double *restrict ARRAY, const unsigned int SIZE, const bool DECREASING) {
//this has the same name as the same R function
	unsigned int *restrict idx = malloc(SIZE * sizeof(unsigned int));
	if (idx == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
	}
	base_arr = malloc(sizeof(double) * SIZE);
	if (base_arr == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
	}
	for (unsigned int i = 0; i < SIZE; i++) {
		base_arr[i] = ARRAY[i];
		idx[i] = i;
	}
	if (DECREASING == false) {
		qsort(idx, SIZE, sizeof(unsigned int), compar_decrease);
	} else if (DECREASING == true) {
		qsort(idx, SIZE, sizeof(unsigned int), compar_increase);
	}
	free(base_arr); base_arr = NULL;
	return idx;
}

double * cummin(const double *restrict ARRAY, const unsigned int NO_OF_ARRAY_ELEMENTS) {
//this takes the same name of the R function which it copies
//this requires a free() afterward where it is used
	if (NO_OF_ARRAY_ELEMENTS < 1) {
		puts("cummin function requires at least one element.\n");
		printf("Failed at %s line %u\n", __FILE__, __LINE__);
		exit(EXIT_FAILURE);
	}
	double *restrict output = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
	if (output == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
	}
	double cumulative_min = ARRAY[0];
	for (unsigned int i = 0; i < NO_OF_ARRAY_ELEMENTS; i++) {
		if (ARRAY[i] < cumulative_min) {
			cumulative_min = ARRAY[i];
		}
		output[i] = cumulative_min;
	}
	return output;
}

double * cummax(const double *restrict ARRAY, const unsigned int NO_OF_ARRAY_ELEMENTS) {
//this takes the same name of the R function which it copies
//this requires a free() afterward where it is used
	if (NO_OF_ARRAY_ELEMENTS < 1) {
		puts("function requires at least one element.\n");
		printf("Failed at %s line %u\n", __FILE__, __LINE__);
		exit(EXIT_FAILURE);
	}
	double *restrict output = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
	if (output == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
	}
	double cumulative_max = ARRAY[0];
	for (unsigned int i = 0; i < NO_OF_ARRAY_ELEMENTS; i++) {
		if (ARRAY[i] > cumulative_max) {
			cumulative_max = ARRAY[i];
		}
		output[i] = cumulative_max;
	}
	return output;
}

double * pminx(const double *restrict ARRAY, const unsigned int NO_OF_ARRAY_ELEMENTS, const double X) {
//named after the R function pmin
	if (NO_OF_ARRAY_ELEMENTS < 1) {
		puts("pmin requires at least one element.\n");
		printf("Failed at %s line %u\n", __FILE__, __LINE__);
		exit(EXIT_FAILURE);
	}
	double *restrict pmin_array = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
	if (pmin_array == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
	}
	for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
		if (ARRAY[index] < X) {
			pmin_array[index] = ARRAY[index];
		} else {
			pmin_array[index] = X;
		}
	}
	return pmin_array;
}

void double_say (const double *restrict ARRAY, const size_t NO_OF_ARRAY_ELEMENTS) {
	printf("[1] %e", ARRAY[0]);
	for (unsigned int i = 1; i < NO_OF_ARRAY_ELEMENTS; i++) {
		printf(" %.10f", ARRAY[i]);
		if (((i+1) % 5) == 0) {
			printf("\n[%u]", i+1);
		}
	}
	puts("\n");
}

/*void uint_say (const unsigned int *restrict ARRAY, const size_t NO_OF_ARRAY_ELEMENTS) {
//for debugging
	printf("%u", ARRAY[0]);
	for (size_t i = 1; i < NO_OF_ARRAY_ELEMENTS; i++) {
		printf(",%u", ARRAY[i]);
	}
	puts("\n");
}*/

double * uint2double (const unsigned int *restrict ARRAY, const unsigned int NO_OF_ARRAY_ELEMENTS) {
	double *restrict doubleArray = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
	if (doubleArray == NULL) {
		printf("Failure to malloc at %s line %u.\n", __FILE__, __LINE__);
		perror("");
		exit(EXIT_FAILURE);
	}
	for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
		doubleArray[index] = (double)ARRAY[index];
	}
	return doubleArray;
}

double min2 (const double N1, const double N2) {
	if (N1 < N2) {
		return N1;
	} else {
		return N2;
	}
}

double * p_adjust (const double *restrict PVALUES, const unsigned int NO_OF_ARRAY_ELEMENTS, const char *restrict STRING) {
//this function is a translation of R's p.adjust "BH" method
// i is always i[index] = NO_OF_ARRAY_ELEMENTS - index - 1
	if (NO_OF_ARRAY_ELEMENTS < 1) {
		puts("p_adjust requires at least one element.\n");
		printf("Failed at %s line %u\n", __FILE__, __LINE__);
		exit(EXIT_FAILURE);
	}
	short int TYPE = -1;
	if (STRING == NULL) {
		TYPE = 0;
	} else if (strcasecmp(STRING, "BH") == 0) {
		TYPE = 0;
	} else if (strcasecmp(STRING, "fdr") == 0) {
		TYPE = 0;
	} else if (strcasecmp(STRING, "by") == 0) {
		TYPE = 1;
	} else if (strcasecmp(STRING, "Bonferroni") == 0) {
		TYPE = 2;
	} else if (strcasecmp(STRING, "hochberg") == 0) {
		TYPE = 3;
	} else if (strcasecmp(STRING, "holm") == 0) {
		TYPE = 4;
	} else if (strcasecmp(STRING, "hommel") == 0) {
		TYPE = 5;
	} else {
		printf("%s doesn't match any accepted FDR methods.\n", STRING);
		printf("Failed at %s line %u\n", __FILE__, __LINE__);
		exit(EXIT_FAILURE);
	}
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
	if (TYPE == 2) {//Bonferroni method
		double *restrict bonferroni = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
		if (bonferroni == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
		}
		for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
			const double BONFERRONI = PVALUES[index] * NO_OF_ARRAY_ELEMENTS;
			if (BONFERRONI >= 1.0) {
				bonferroni[index] = 1.0;
			} else if ((0.0 <= BONFERRONI) && (BONFERRONI < 1.0)) {
				bonferroni[index] = BONFERRONI;
			} else {
				printf("%g is outside of the interval I planned.\n", BONFERRONI);
				printf("Failure at %s line %u\n", __FILE__, __LINE__);
				exit(EXIT_FAILURE);
			}
		}
		return bonferroni;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
	} else if (TYPE == 4) {//Holm method
/*these values are computed separately from BH, BY, and Hochberg because they are
computed differently*/
		unsigned int *restrict o  = order(PVALUES, NO_OF_ARRAY_ELEMENTS, false);
//sorted in reverse of methods 0-3
		double *restrict o2double = uint2double(o, NO_OF_ARRAY_ELEMENTS);
		double *restrict cummax_input = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
		for (unsigned index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
			cummax_input[index] = (NO_OF_ARRAY_ELEMENTS - index ) * (double)PVALUES[o[index]];
//			printf("cummax_input[%zu] = %e\n", index, cummax_input[index]);
		}
		free(o); o = NULL;
		unsigned int *restrict ro = order(o2double, NO_OF_ARRAY_ELEMENTS, false);
		free(o2double); o2double = NULL;

		double *restrict cummax_output = cummax(cummax_input, NO_OF_ARRAY_ELEMENTS);
		free(cummax_input); cummax_input = NULL;

		double *restrict pmin = pminx(cummax_output, NO_OF_ARRAY_ELEMENTS, 1);
		free(cummax_output); cummax_output = NULL;
		double *restrict qvalues = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
		for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
			qvalues[index] = pmin[ro[index]];
		}
		free(pmin); pmin = NULL;
		free(ro); ro = NULL;
		return qvalues;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
	} else if (TYPE == 5) {//Hommel method
//i <- seq_len(n)
//o <- order(p)
		unsigned int *restrict o = order(PVALUES, NO_OF_ARRAY_ELEMENTS, false);//false is R's default
//p <- p[o]
		double *restrict p = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
		if (p == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
		}
		for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
			p[index] = PVALUES[o[index]];
		}
//ro <- order(o)
		double *restrict o2double = uint2double(o, NO_OF_ARRAY_ELEMENTS);
		free(o); o = NULL;
		unsigned int *restrict ro = order(o2double, NO_OF_ARRAY_ELEMENTS, false);
		free(o2double); o2double = NULL;
//		puts("ro");
//q <- pa <- rep.int(min(n * p/i), n)
		double *restrict q   = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
		if (q == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
		}
		double *restrict pa  = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
		if (pa == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
		}
		double min = (double)NO_OF_ARRAY_ELEMENTS * p[0];
		for (unsigned index = 1; index < NO_OF_ARRAY_ELEMENTS; index++) {
			const double TEMP = (double)NO_OF_ARRAY_ELEMENTS * p[index] / (double)(1+index);
			if (TEMP < min) {
				min = TEMP;
			}
		}
		for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
			pa[index] = min;
			 q[index] = min;
		}
//		puts("q & pa");
//		double_say(q, NO_OF_ARRAY_ELEMENTS);
/*for (j in (n - 1):2) {
            ij <- seq_len(n - j + 1)
            i2 <- (n - j + 2):n
            q1 <- min(j * p[i2]/(2:j))
            q[ij] <- pmin(j * p[ij], q1)
            q[i2] <- q[n - j + 1]
            pa <- pmax(pa, q)
        }
*/
		for (unsigned j = (NO_OF_ARRAY_ELEMENTS-1); j >= 2; j--) {
//			printf("j = %zu\n", j);
			unsigned int *restrict ij = seq_len(0,NO_OF_ARRAY_ELEMENTS - j);
			const size_t I2_LENGTH = j - 1;
			unsigned int *restrict i2 = malloc(I2_LENGTH * sizeof(unsigned int));
			for (unsigned i = 0; i < I2_LENGTH; i++) {
				i2[i] = NO_OF_ARRAY_ELEMENTS-j+2+i-1;
//R's indices are 1-based, C's are 0-based, I added the -1
			}

			double q1 = (double)j * p[i2[0]] / 2.0;
			for (unsigned int i = 1; i < I2_LENGTH; i++) {//loop through 2:j
				const double TEMP_Q1 = (double)j * p[i2[i]] / (double)(2 + i);
				if (TEMP_Q1 < q1) {
					q1 = TEMP_Q1;
				}
			}

			for (unsigned int i = 0; i < (NO_OF_ARRAY_ELEMENTS - j + 1); i++) {//q[ij] <- pmin(j * p[ij], q1)
				q[ij[i]] = min2( (double)j*p[ij[i]], q1);
			}
			free(ij); ij = NULL;

			for (unsigned int i = 0; i < I2_LENGTH; i++) {//q[i2] <- q[n - j + 1]
				q[i2[i]] = q[NO_OF_ARRAY_ELEMENTS - j];//subtract 1 because of starting index difference
			}
			free(i2); i2 = NULL;

			for (unsigned int i = 0; i < NO_OF_ARRAY_ELEMENTS; i++) {//pa <- pmax(pa, q)
				if (pa[i] < q[i]) {
					pa[i] = q[i];
				}
			}
//			printf("j = %zu, pa = \n", j);
//				double_say(pa, N);
		}//end j loop
		free(p); p = NULL;
		for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
			q[index] = pa[ro[index]];//Hommel q-values
		}
//now free memory
		free(ro); ro = NULL;
		free(pa); pa = NULL;
		return q;
	}
//The methods are similarly computed and thus can be combined for clarity
	unsigned int *restrict o = order(PVALUES, NO_OF_ARRAY_ELEMENTS, true);
	if (o == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
	}
	double *restrict o_double = uint2double(o, NO_OF_ARRAY_ELEMENTS);
	for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
		if ((PVALUES[index] < 0) || (PVALUES[index] > 1)) {
			printf("array[%u] = %lf, which is outside the interval [0,1]\n", index, PVALUES[index]);
			printf("died at %s line %u\n", __FILE__, __LINE__);
			exit(EXIT_FAILURE);
		}
	}

	unsigned int *restrict ro = order(o_double, NO_OF_ARRAY_ELEMENTS, false);
	if (ro == NULL) {
			printf("failed to malloc at %s line %u.\n", __FILE__, __LINE__);
			perror("");
			exit(EXIT_FAILURE);
	}
	free(o_double); o_double = NULL;
	double *restrict cummin_input = malloc(sizeof(double) * NO_OF_ARRAY_ELEMENTS);
	if (TYPE == 0) {//BH method
		for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
			const double NI = (double)NO_OF_ARRAY_ELEMENTS / (double)(NO_OF_ARRAY_ELEMENTS - index);// n/i simplified
			cummin_input[index] = NI * PVALUES[o[index]];//PVALUES[o[index]] is p[o]
		}
	} else if (TYPE == 1) {//BY method
		double q = 1.0;
		for (unsigned int index = 2; index < (1+NO_OF_ARRAY_ELEMENTS); index++) {
			q +=  1.0/(double)index;
		}
		for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
			const double NI = (double)NO_OF_ARRAY_ELEMENTS / (double)(NO_OF_ARRAY_ELEMENTS - index);// n/i simplified
			cummin_input[index] = q * NI * PVALUES[o[index]];//PVALUES[o[index]] is p[o]
		}
	} else if (TYPE == 3) {//Hochberg method
		for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
// pmin(1, cummin((n - i + 1L) * p[o]))[ro]
			cummin_input[index] = (double)(index + 1) * PVALUES[o[index]];
		}
	}
	free(o); o = NULL;
	double *restrict cummin_array = NULL;
	cummin_array = cummin(cummin_input, NO_OF_ARRAY_ELEMENTS);
	free(cummin_input); cummin_input = NULL;//I don't need this anymore
	double *restrict pmin = pminx(cummin_array, NO_OF_ARRAY_ELEMENTS, 1);
	free(cummin_array); cummin_array = NULL;
	double *restrict q_array = malloc(NO_OF_ARRAY_ELEMENTS*sizeof(double));
	for (unsigned int index = 0; index < NO_OF_ARRAY_ELEMENTS; index++) {
		q_array[index] = pmin[ro[index]];
	}

	free(ro); ro = NULL;
	free(pmin); pmin = NULL;
	return q_array;
}


int main(void) {
	const double PVALUES[] = {4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03};//just the pvalues
	const double CORRECT_ANSWERS[6][50] = {//each first index is type
	{6.126681e-01, 8.521710e-01, 1.987205e-01, 1.891595e-01, 3.217789e-01,
9.301450e-01, 4.870370e-01, 9.301450e-01, 6.049731e-01, 6.826753e-01,
6.482629e-01, 7.253722e-01, 5.280973e-01, 8.769926e-01, 4.705703e-01,
9.241867e-01, 6.049731e-01, 7.856107e-01, 4.887526e-01, 1.136717e-01,
4.991891e-01, 8.769926e-01, 9.991834e-01, 3.217789e-01, 9.301450e-01,
2.304958e-01, 5.832475e-01, 3.899547e-02, 8.521710e-01, 1.476843e-01,
1.683638e-02, 2.562902e-03, 3.516084e-02, 6.250189e-02, 3.636589e-03,
2.562902e-03, 2.946883e-02, 6.166064e-03, 3.899547e-02, 2.688991e-03,
4.502862e-04, 1.252228e-05, 7.881555e-02, 3.142613e-02, 4.846527e-03,
2.562902e-03, 4.846527e-03, 1.101708e-03, 7.252032e-02, 2.205958e-02},//Benjamini-Hochberg
	{1.000000e+00, 1.000000e+00, 8.940844e-01, 8.510676e-01, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 5.114323e-01,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.754486e-01, 1.000000e+00, 6.644618e-01,
7.575031e-02, 1.153102e-02, 1.581959e-01, 2.812089e-01, 1.636176e-02,
1.153102e-02, 1.325863e-01, 2.774239e-02, 1.754486e-01, 1.209832e-02,
2.025930e-03, 5.634031e-05, 3.546073e-01, 1.413926e-01, 2.180552e-02,
1.153102e-02, 2.180552e-02, 4.956812e-03, 3.262838e-01, 9.925057e-02},//Benjamini & Yekutieli
	{1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 7.019185e-01, 1.000000e+00, 1.000000e+00,
2.020365e-01, 1.516674e-02, 5.625735e-01, 1.000000e+00, 2.909271e-02,
1.537741e-02, 4.125636e-01, 6.782670e-02, 6.803480e-01, 1.882294e-02,
9.005725e-04, 1.252228e-05, 1.000000e+00, 4.713920e-01, 4.395577e-02,
1.088915e-02, 4.846527e-02, 3.305125e-03, 1.000000e+00, 2.867745e-01},//Bonferroni
{9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 4.632662e-01, 9.991834e-01, 9.991834e-01,
1.575885e-01, 1.383967e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
1.383967e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01},//Hochberg
	{1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 4.632662e-01, 1.000000e+00, 1.000000e+00,
1.575885e-01, 1.395341e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
1.395341e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01},//Holm
{ 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.987624e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.595180e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 4.351895e-01, 9.991834e-01, 9.766522e-01,
1.414256e-01, 1.304340e-02, 3.530937e-01, 6.887709e-01, 2.385602e-02,
1.322457e-02, 2.722920e-01, 5.426136e-02, 4.218158e-01, 1.581127e-02,
8.825610e-04, 1.252228e-05, 8.743649e-01, 3.016908e-01, 3.516461e-02,
9.582456e-03, 3.877222e-02, 3.172920e-03, 8.122276e-01, 1.950067e-01}//Hommel
	};
//the following loop checks each type with R's answers
	const char *restrict TYPES[] = {"bh", "by", "bonferroni", "hochberg", "holm", "hommel"};
	for (unsigned short int type = 0; type <= 5; type++) {
		double *restrict q = p_adjust(PVALUES, sizeof(PVALUES) / sizeof(*PVALUES), TYPES[type]);
		double error = fabs(q[0] - CORRECT_ANSWERS[type][0]);
//		printf("%e	-	%e	=	%g\n", q[0], CORRECT_ANSWERS[type][0], error);
	//	puts("p	q");
	//	printf("%g\t%g\n", pvalues[0], q[0]);
		for (unsigned int i = 1; i < sizeof(PVALUES) / sizeof(*PVALUES); i++) {
			const double this_error = fabs(q[i] - CORRECT_ANSWERS[type][i]);
//			printf("%e	-	%e	=	%g\n", q[i], CORRECT_ANSWERS[type][i], error);
			error += this_error;
		}
		double_say(q, sizeof(PVALUES) / sizeof(*PVALUES));
		free(q); q = NULL;
		printf("\ntype %u = '%s' has cumulative error of %g\n", type, TYPES[type], error);
	}
	
	return 0;
}
