#include <iostream>
#include <iomanip>
#include <cmath>

namespace Rosetta {

    /*! Implementation of Gauss-Legendre quadrature
    *  http://en.wikipedia.org/wiki/Gaussian_quadrature
    *  http://rosettacode.org/wiki/Numerical_integration/Gauss-Legendre_Quadrature
    *
    */
    template <int N>
    class GaussLegendreQuadrature {
    public:
        enum {eDEGREE = N};

        /*! Compute the integral of a functor
        *
        *   @param a    lower limit of integration
        *   @param b    upper limit of integration
        *   @param f    the function to integrate
        *   @param err  callback in case of problems
        */
        template <typename Function>
        double integrate(double a, double b, Function f) {
            double p = (b - a) / 2;
            double q = (b + a) / 2;
            const LegendrePolynomial& legpoly = s_LegendrePolynomial;

            double sum = 0;
            for (int i = 1; i <= eDEGREE; ++i) {
                sum += legpoly.weight(i) * f(p * legpoly.root(i) + q);
            }

            return p * sum;
        }

        /*! Print out roots and weights for information
        */
        void print_roots_and_weights(std::ostream& out) const {
            const LegendrePolynomial& legpoly = s_LegendrePolynomial;
            out << "Roots:  ";
            for (int i = 0; i <= eDEGREE; ++i) {
                out << ' ' << legpoly.root(i);
            }
            out << std::endl;
            out << "Weights:";
            for (int i = 0; i <= eDEGREE; ++i) {
                out << ' ' << legpoly.weight(i);
            }
            out << std::endl;
        }
    private:
        /*! Implementation of the Legendre polynomials that form
        *   the basis of this quadrature
        */
        class LegendrePolynomial {
        public:
            LegendrePolynomial () {
                // Solve roots and weights
                for (int i = 0; i <= eDEGREE; ++i) {
                    double dr = 1;

                    // Find zero
                    Evaluation eval(cos(M_PI * (i - 0.25) / (eDEGREE + 0.5)));
                    do {
                        dr = eval.v() / eval.d();
                        eval.evaluate(eval.x() - dr);
                    } while (fabs (dr) > 2e-16);

                    this->_r[i] = eval.x();
                    this->_w[i] = 2 / ((1 - eval.x() * eval.x()) * eval.d() * eval.d());
                }
            }

            double root(int i) const { return this->_r[i]; }
            double weight(int i) const { return this->_w[i]; }
        private:
            double _r[eDEGREE + 1];
            double _w[eDEGREE + 1];

            /*! Evaluate the value *and* derivative of the
            *   Legendre polynomial
            */
            class Evaluation {
            public:
                explicit Evaluation (double x) : _x(x), _v(1), _d(0) {
                    this->evaluate(x);
                }

                void evaluate(double x) {
                    this->_x = x;

                    double vsub1 = x;
                    double vsub2 = 1;
                    double f     = 1 / (x * x - 1);

                    for (int i = 2; i <= eDEGREE; ++i) {
                        this->_v = ((2 * i - 1) * x * vsub1 - (i - 1) * vsub2) / i;
                        this->_d = i * f * (x * this->_v - vsub1);

                        vsub2 = vsub1;
                        vsub1 = this->_v;
                    }
                }

                double v() const { return this->_v; }
                double d() const { return this->_d; }
                double x() const { return this->_x; }

            private:
                double _x;
                double _v;
                double _d;
            };
        };

        /*! Pre-compute the weights and abscissae of the Legendre polynomials
        */
        static LegendrePolynomial s_LegendrePolynomial;
    };

    template <int N>
    typename GaussLegendreQuadrature<N>::LegendrePolynomial GaussLegendreQuadrature<N>::s_LegendrePolynomial;
}

// This to avoid issues with exp being a templated function
double RosettaExp(double x) {
    return exp(x);
}

int main() {
    Rosetta::GaussLegendreQuadrature<5> gl5;

    std::cout << std::setprecision(10);

    gl5.print_roots_and_weights(std::cout);
    std::cout << "Integrating Exp(X) over [-3, 3]: " << gl5.integrate(-3., 3., RosettaExp) << std::endl;
    std::cout << "Actual value:                    " << RosettaExp(3) - RosettaExp(-3) << std::endl;
}
