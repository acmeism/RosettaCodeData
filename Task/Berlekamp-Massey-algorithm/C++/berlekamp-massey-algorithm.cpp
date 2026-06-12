#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>

class BerlekampMassey {
private:
    std::vector<int> source;
    int modulus;

    std::vector<int> polynomial_multiply(const std::vector<int>& a, const std::vector<int>& b,
                                       size_t degree, const std::vector<int>& coeffs) {
        std::vector<int> result(2 * degree, 0);

        for (size_t i = 0; i < degree; ++i) {
            if (a[i] == 0) continue;
            for (size_t j = 0; j < degree; ++j) {
                result[i + j] = (result[i + j] + a[i] * b[j]) % modulus;
            }
        }

        for (size_t i = 2 * degree - 1; i >= degree; --i) {
            if (result[i] == 0) continue;

            int term = result[i];
            result[i] = 0;

            for (size_t j = 0; j <= degree; ++j) {
                size_t index = i - j;
                if (index < result.size()) {
                    result[index] = (result[index] + term * coeffs[j]) % modulus;
                }
            }
        }

        return std::vector<int>(result.begin(), result.begin() + degree);
    }

public:
    BerlekampMassey(const std::vector<int>& source, int modulus)
        : source(source), modulus(modulus) {}

    std::vector<int> compute_coefficients() {
        std::vector<int> result;
        std::vector<int> previous_result;
        int fail_index = -1;

        for (size_t i = 0; i < source.size(); ++i) {
            int delta = source[i];
            for (size_t j = 1; j <= result.size(); ++j) {
                delta -= result[j - 1] * source[i - j];
            }

            if (delta == 0) {
                continue;
            }

            if (fail_index == -1) {
                result.assign(i + 1, 0);
                fail_index = static_cast<int>(i);
            } else {
                std::vector<int> previous_result_copy;
                previous_result_copy.push_back(1);
                for (int term : previous_result) {
                    previous_result_copy.push_back(-term);
                }

                int term_fail_index_plus_one = 0;
                for (size_t j = 1; j <= previous_result_copy.size(); ++j) {
                    term_fail_index_plus_one += previous_result_copy[j - 1] *
                        source[fail_index + 1 - j];
                }

                int coeff = delta / term_fail_index_plus_one;
                for (int& val : previous_result_copy) {
                    val *= coeff;
                }

                for (int k = 0; k < static_cast<int>(i) - fail_index - 1; ++k) {
                    previous_result_copy.insert(previous_result_copy.begin(), 0);
                }

                std::vector<int> result_copy = result;
                while (result.size() < previous_result_copy.size()) {
                    result.push_back(0);
                }

                for (size_t j = 0; j < previous_result_copy.size(); ++j) {
                    result[j] += previous_result_copy[j];
                }

                if (static_cast<int>(i) - static_cast<int>(result_copy.size()) >
                    fail_index - static_cast<int>(previous_result.size())) {
                    previous_result = result_copy;
                    fail_index = static_cast<int>(i);
                }
            }
        }
        return result;
    }

    int compute_term(const std::vector<int>& bm_coeffs, size_t index) {
        if (bm_coeffs.empty()) {
            return 0;
        }

        if (index < source.size()) {
            return (source[index] + modulus) % modulus;
        }

        std::vector<int> coeffs;
        coeffs.push_back(modulus - 1);
        coeffs.insert(coeffs.end(), bm_coeffs.begin(), bm_coeffs.end());

        size_t bm_coeffs_size = bm_coeffs.size();
        std::vector<int> f(bm_coeffs_size, 0);
        std::vector<int> g(bm_coeffs_size, 0);

        f[0] = 1;

        if (bm_coeffs_size == 1) {
            g[0] = coeffs[1];
        } else {
            g[1] = 1;
        }

        size_t power = index - 1;
        while (power > 0) {
            if ((power & 1) == 1) {
                f = polynomial_multiply(f, g, bm_coeffs_size, coeffs);
            }
            g = polynomial_multiply(g, g, bm_coeffs_size, coeffs);
            power >>= 1;
        }

        int result = 0;
        for (size_t i = 0; i < bm_coeffs_size; ++i) {
            if (i + 1 < source.size()) {
                result = (result + source[i + 1] * f[i]) % modulus;
            }
        }
        return (result + modulus) % modulus;
    }

    std::string polynomial(const std::vector<int>& bm_coeffs) {
        if (bm_coeffs.empty()) return "0";

        int degree = static_cast<int>(bm_coeffs.size()) - 1;
        if (degree == 0) {
            return std::to_string(bm_coeffs[0]);
        }

        std::string text;
        for (int i = degree; i >= 0; --i) {
            int coeff = bm_coeffs[i];
            if (coeff == 0) {
                continue;
            }

            std::string sign;
            if (coeff < 0 && i == degree) {
                sign = "-";
            } else if (coeff < 0) {
                sign = " - ";
            } else if (i < degree) {
                sign = " + ";
            }
            text += sign;

            int coeff_abs = std::abs(coeff);
            if (coeff_abs > 1) {
                text += std::to_string(coeff_abs);
            }

            std::string term;
            if (i > 1) {
                term = "x^" + std::to_string(i);
            } else if (i == 1) {
                term = "x";
            } else if (coeff_abs == 1) {
                term = "1";
            }
            text += term;
        }
        return text;
    }
};

int main() {
    std::vector<int> source = {0, 1, 1, 2, 3, 5, 8, 13, 21};
    BerlekampMassey bm(source, 100);
    std::vector<int> bm_coeffs = bm.compute_coefficients();

    std::cout << "Berlekamp-Massey coefficients: [";
    for (size_t i = 0; i < bm_coeffs.size(); ++i) {
        if (i > 0) std::cout << ", ";
        std::cout << bm_coeffs[i];
    }
    std::cout << "] (lowest to highest degree)" << std::endl;

    std::cout << "The connection polynomial is " << bm.polynomial(bm_coeffs)
              << " having degree " << bm_coeffs.size() - 1 << std::endl << std::endl;

    std::cout << "Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:" << std::endl;
    // Result can be checked on www.oeis.net, A000045
    std::vector<int> indices = {35, 36, 37, 38, 39, 40};
    for (size_t i = 0; i < indices.size(); ++i) {
        if (i > 0) std::cout << " ";
        std::cout << bm.compute_term(bm_coeffs, indices[i]);
    }
    std::cout << std::endl;

    return 0;
}
