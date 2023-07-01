#include <algorithm>
#include <iostream>
#include <initializer_list>
#include <map>
#include <vector>

const int MAX_ALL_FACTORS = 100000;
const int algorithm = 2;
int divisions = 0;

//Note: Cyclotomic Polynomials have small coefficients.  Not appropriate for general polynomial usage.
class Term {
private:
    long m_coefficient;
    long m_exponent;

public:
    Term(long c, long e) : m_coefficient(c), m_exponent(e) {
        // empty
    }

    Term(const Term &t) : m_coefficient(t.m_coefficient), m_exponent(t.m_exponent) {
        // empty
    }

    long coefficient() const {
        return m_coefficient;
    }

    long degree() const {
        return m_exponent;
    }

    Term operator -() const {
        return { -m_coefficient, m_exponent };
    }

    Term operator *(const Term &rhs) const {
        return { m_coefficient * rhs.m_coefficient, m_exponent + rhs.m_exponent };
    }

    Term operator +(const Term &rhs) const {
        if (m_exponent != rhs.m_exponent) {
            throw std::runtime_error("Exponents not equal");
        }
        return { m_coefficient + rhs.m_coefficient, m_exponent };
    }

    friend std::ostream &operator<<(std::ostream &, const Term &);
};

std::ostream &operator<<(std::ostream &os, const Term &t) {
    if (t.m_coefficient == 0) {
        return os << '0';
    }
    if (t.m_exponent == 0) {
        return os << t.m_coefficient;
    }
    if (t.m_coefficient == 1) {
        if (t.m_exponent == 1) {
            return os << 'x';
        }
        return os << "x^" << t.m_exponent;
    }
    if (t.m_coefficient == -1) {
        if (t.m_exponent == 1) {
            return os << "-x";
        }
        return os << "-x^" << t.m_exponent;
    }
    if (t.m_exponent == 1) {
        return os << t.m_coefficient << 'x';
    }
    return os << t.m_coefficient << "x^" << t.m_exponent;
}

class Polynomial {
public:
    std::vector<Term> polynomialTerms;

    Polynomial() {
        polynomialTerms.push_back({ 0, 0 });
    }

    Polynomial(std::initializer_list<int> values) {
        if (values.size() % 2 != 0) {
            throw std::runtime_error("Length must be even.");
        }

        bool ready = false;
        long t;
        for (auto v : values) {
            if (ready) {
                polynomialTerms.push_back({ t, v });
            } else {
                t = v;
            }
            ready = !ready;
        }
        std::sort(
            polynomialTerms.begin(), polynomialTerms.end(),
            [](const Term &t, const Term &u) {
                return u.degree() < t.degree();
            }
        );
    }

    Polynomial(const std::vector<Term> &termList) {
        if (termList.size() == 0) {
            polynomialTerms.push_back({ 0, 0 });
        } else {
            for (auto t : termList) {
                if (t.coefficient() != 0) {
                    polynomialTerms.push_back(t);
                }
            }
            if (polynomialTerms.size() == 0) {
                polynomialTerms.push_back({ 0, 0 });
            }
            std::sort(
                polynomialTerms.begin(), polynomialTerms.end(),
                [](const Term &t, const Term &u) {
                    return u.degree() < t.degree();
                }
            );
        }
    }

    Polynomial(const Polynomial &p) : Polynomial(p.polynomialTerms) {
        // empty
    }

    long leadingCoefficient() const {
        return polynomialTerms[0].coefficient();
    }

    long degree() const {
        return polynomialTerms[0].degree();
    }

    bool hasCoefficientAbs(int coeff) {
        for (auto term : polynomialTerms) {
            if (abs(term.coefficient()) == coeff) {
                return true;
            }
        }
        return false;
    }

    Polynomial operator+(const Term &term) const {
        std::vector<Term> termList;
        bool added = false;
        for (size_t index = 0; index < polynomialTerms.size(); index++) {
            auto currentTerm = polynomialTerms[index];
            if (currentTerm.degree() == term.degree()) {
                added = true;
                if (currentTerm.coefficient() + term.coefficient() != 0) {
                    termList.push_back(currentTerm + term);
                }
            } else {
                termList.push_back(currentTerm);
            }
        }
        if (!added) {
            termList.push_back(term);
        }
        return Polynomial(termList);
    }

    Polynomial operator*(const Term &term) const {
        std::vector<Term> termList;
        for (size_t index = 0; index < polynomialTerms.size(); index++) {
            auto currentTerm = polynomialTerms[index];
            termList.push_back(currentTerm * term);
        }
        return Polynomial(termList);
    }

    Polynomial operator+(const Polynomial &p) const {
        std::vector<Term> termList;
        int thisCount = polynomialTerms.size();
        int polyCount = p.polynomialTerms.size();
        while (thisCount > 0 || polyCount > 0) {
            if (thisCount == 0) {
                auto polyTerm = p.polynomialTerms[polyCount - 1];
                termList.push_back(polyTerm);
                polyCount--;
            } else if (polyCount == 0) {
                auto thisTerm = polynomialTerms[thisCount - 1];
                termList.push_back(thisTerm);
                thisCount--;
            } else {
                auto polyTerm = p.polynomialTerms[polyCount - 1];
                auto thisTerm = polynomialTerms[thisCount - 1];
                if (thisTerm.degree() == polyTerm.degree()) {
                    auto t = thisTerm + polyTerm;
                    if (t.coefficient() != 0) {
                        termList.push_back(t);
                    }
                    thisCount--;
                    polyCount--;
                } else if (thisTerm.degree() < polyTerm.degree()) {
                    termList.push_back(thisTerm);
                    thisCount--;
                } else {
                    termList.push_back(polyTerm);
                    polyCount--;
                }
            }
        }
        return Polynomial(termList);
    }

    Polynomial operator/(const Polynomial &v) {
        divisions++;

        Polynomial q;
        Polynomial r(*this);
        long lcv = v.leadingCoefficient();
        long dv = v.degree();
        while (r.degree() >= v.degree()) {
            long lcr = r.leadingCoefficient();
            long s = lcr / lcv;
            Term term(s, r.degree() - dv);
            q = q + term;
            r = r + v * -term;
        }

        return q;
    }

    friend std::ostream &operator<<(std::ostream &, const Polynomial &);
};

std::ostream &operator<<(std::ostream &os, const Polynomial &p) {
    auto it = p.polynomialTerms.cbegin();
    auto end = p.polynomialTerms.cend();
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        if (it->coefficient() > 0) {
            os << " + " << *it;
        } else {
            os << " - " << -*it;
        }
        it = std::next(it);
    }
    return os;
}

std::vector<int> getDivisors(int number) {
    std::vector<int> divisiors;
    long root = (long)sqrt(number);
    for (int i = 1; i <= root; i++) {
        if (number % i == 0) {
            divisiors.push_back(i);
            int div = number / i;
            if (div != i && div != number) {
                divisiors.push_back(div);
            }
        }
    }
    return divisiors;
}

std::map<int, std::map<int, int>> allFactors;

std::map<int, int> getFactors(int number) {
    if (allFactors.find(number) != allFactors.end()) {
        return allFactors[number];
    }

    std::map<int, int> factors;
    if (number % 2 == 0) {
        auto factorsDivTwo = getFactors(number / 2);
        factors.insert(factorsDivTwo.begin(), factorsDivTwo.end());
        if (factors.find(2) != factors.end()) {
            factors[2]++;
        } else {
            factors.insert(std::make_pair(2, 1));
        }
        if (number < MAX_ALL_FACTORS) {
            allFactors.insert(std::make_pair(number, factors));
        }
        return factors;
    }
    long root = (long)sqrt(number);
    long i = 3;
    while (i <= root) {
        if (number % i == 0) {
            auto factorsDivI = getFactors(number / i);
            factors.insert(factorsDivI.begin(), factorsDivI.end());
            if (factors.find(i) != factors.end()) {
                factors[i]++;
            } else {
                factors.insert(std::make_pair(i, 1));
            }
            if (number < MAX_ALL_FACTORS) {
                allFactors.insert(std::make_pair(number, factors));
            }
            return factors;
        }
        i += 2;
    }
    factors.insert(std::make_pair(number, 1));
    if (number < MAX_ALL_FACTORS) {
        allFactors.insert(std::make_pair(number, factors));
    }
    return factors;
}

std::map<int, Polynomial> COMPUTED;
Polynomial cyclotomicPolynomial(int n) {
    if (COMPUTED.find(n) != COMPUTED.end()) {
        return COMPUTED[n];
    }

    if (n == 1) {
        // Polynomial: x - 1
        Polynomial p({ 1, 1, -1, 0 });
        COMPUTED.insert(std::make_pair(1, p));
        return p;
    }

    auto factors = getFactors(n);
    if (factors.find(n) != factors.end()) {
        // n prime
        std::vector<Term> termList;
        for (int index = 0; index < n; index++) {
            termList.push_back({ 1, index });
        }

        Polynomial cyclo(termList);
        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    } else if (factors.size() == 2 && factors.find(2) != factors.end() && factors[2] == 1 && factors.find(n / 2) != factors.end() && factors[n / 2] == 1) {
        // n = 2p
        int prime = n / 2;
        std::vector<Term> termList;
        int coeff = -1;

        for (int index = 0; index < prime; index++) {
            coeff *= -1;
            termList.push_back({ coeff, index });
        }

        Polynomial cyclo(termList);
        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    } else if (factors.size() == 1 && factors.find(2) != factors.end()) {
        // n = 2^h
        int h = factors[2];
        std::vector<Term> termList;
        termList.push_back({ 1, (int)pow(2, h - 1) });
        termList.push_back({ 1, 0 });

        Polynomial cyclo(termList);
        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    } else if (factors.size() == 1 && factors.find(n) != factors.end()) {
        // n = p^k
        int p = 0;
        int k = 0;
        for (auto iter = factors.begin(); iter != factors.end(); ++iter) {
            p = iter->first;
            k = iter->second;
        }
        std::vector<Term> termList;
        for (int index = 0; index < p; index++) {
            termList.push_back({ 1, index * (int)pow(p, k - 1) });
        }

        Polynomial cyclo(termList);
        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    } else if (factors.size() == 2 && factors.find(2) != factors.end()) {
        // n = 2^h * p^k
        int p = 0;
        for (auto iter = factors.begin(); iter != factors.end(); ++iter) {
            if (iter->first != 2) {
                p = iter->first;
            }
        }

        std::vector<Term> termList;
        int coeff = -1;
        int twoExp = (int)pow(2, factors[2] - 1);
        int k = factors[p];
        for (int index = 0; index < p; index++) {
            coeff *= -1;
            termList.push_back({ coeff, index * twoExp * (int)pow(p, k - 1) });
        }

        Polynomial cyclo(termList);
        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    } else if (factors.find(2) != factors.end() && ((n / 2) % 2 == 1) && (n / 2) > 1) {
        //  CP(2m)[x] = CP(-m)[x], n odd integer > 1
        auto cycloDiv2 = cyclotomicPolynomial(n / 2);
        std::vector<Term> termList;
        for (auto term : cycloDiv2.polynomialTerms) {
            if (term.degree() % 2 == 0) {
                termList.push_back(term);
            } else {
                termList.push_back(-term);
            }
        }

        Polynomial cyclo(termList);
        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    }

    // General Case

    if (algorithm == 0) {
        // slow - uses basic definition
        auto divisors = getDivisors(n);
        // Polynomial: (x^n - 1)
        Polynomial cyclo({ 1, n, -1, 0 });
        for (auto i : divisors) {
            auto p = cyclotomicPolynomial(i);
            cyclo = cyclo / p;
        }

        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    } else if (algorithm == 1) {
        //  Faster.  Remove Max divisor (and all divisors of max divisor) - only one divide for all divisors of Max Divisor
        auto divisors = getDivisors(n);
        int maxDivisor = INT_MIN;
        for (auto div : divisors) {
            maxDivisor = std::max(maxDivisor, div);
        }
        std::vector<int> divisorExceptMax;
        for (auto div : divisors) {
            if (maxDivisor % div != 0) {
                divisorExceptMax.push_back(div);
            }
        }

        //  Polynomial:  ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
        auto cyclo = Polynomial({ 1, n, -1, 0 }) / Polynomial({ 1, maxDivisor, -1, 0 });
        for (int i : divisorExceptMax) {
            auto p = cyclotomicPolynomial(i);
            cyclo = cyclo / p;
        }

        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    } else if (algorithm == 2) {
        //  Fastest
        //  Let p ; q be primes such that p does not divide n, and q q divides n.
        //  Then CP(np)[x] = CP(n)[x^p] / CP(n)[x]
        int m = 1;
        auto cyclo = cyclotomicPolynomial(m);
        std::vector<int> primes;
        for (auto iter = factors.begin(); iter != factors.end(); ++iter) {
            primes.push_back(iter->first);
        }
        std::sort(primes.begin(), primes.end());
        for (auto prime : primes) {
            //  CP(m)[x]
            auto cycloM = cyclo;
            //  Compute CP(m)[x^p].
            std::vector<Term> termList;
            for (auto t : cycloM.polynomialTerms) {
                termList.push_back({ t.coefficient(), t.degree() * prime });
            }
            cyclo = Polynomial(termList) / cycloM;
            m = m * prime;
        }
        //  Now, m is the largest square free divisor of n
        int s = n / m;
        //  Compute CP(n)[x] = CP(m)[x^s]
        std::vector<Term> termList;
        for (auto t : cyclo.polynomialTerms) {
            termList.push_back({ t.coefficient(), t.degree() * s });
        }

        cyclo = Polynomial(termList);
        COMPUTED.insert(std::make_pair(n, cyclo));
        return cyclo;
    } else {
        throw std::runtime_error("Invalid algorithm");
    }
}

int main() {
    // initialization
    std::map<int, int> factors;
    factors.insert(std::make_pair(2, 1));
    allFactors.insert(std::make_pair(2, factors));

    // rest of main
    std::cout << "Task 1:  cyclotomic polynomials for n <= 30:\n";
    for (int i = 1; i <= 30; i++) {
        auto p = cyclotomicPolynomial(i);
        std::cout << "CP[" << i << "] = " << p << '\n';
    }

    std::cout << "Task 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:\n";
    int n = 0;
    for (int i = 1; i <= 10; i++) {
        while (true) {
            n++;
            auto cyclo = cyclotomicPolynomial(n);
            if (cyclo.hasCoefficientAbs(i)) {
                std::cout << "CP[" << n << "] has coefficient with magnitude = " << i << '\n';
                n--;
                break;
            }
        }
    }

    return 0;
}
