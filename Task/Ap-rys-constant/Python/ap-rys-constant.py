from sympy import zeta, factorial
from decimal import Decimal, getcontext

# Set the desired precision
getcontext().prec = 120

def my_sympy_format_to_decimal(sympy_result):
    return Decimal(str(sympy_result.evalf(getcontext().prec)))

def print_apery_constant(description, value):
    print(f"{description}:\n{str(value)[:102]}")

# Apéry's constant via SymPy's zeta function
zeta_3_str = str(zeta(3).evalf(getcontext().prec))
zeta_3_decimal = Decimal(zeta_3_str)
print_apery_constant("Apéry's constant via SymPy's zeta", zeta_3_decimal)

# Apéry's constant via Riemann summation of 1/(k cubed)
def apery_r(nterms=1_000):
    total = sum(Decimal('1') / Decimal(k) ** 3 for k in range(1, nterms + 1))
    return total
print_apery_constant("Apéry's constant via reciprocal cubes", apery_r())

# Apéry's constant via Markov's summation
def apery_m(nterms=158):
    total = Decimal(2.5) * sum(
        (Decimal(1) if k % 2 != 0 else Decimal(-1)) *
        my_sympy_format_to_decimal(factorial(k) ** 2) /
        my_sympy_format_to_decimal(factorial(2*k)  * (k ** 3) )
        for k in range(1, nterms + 1)
    )
    return total
print_apery_constant("Apéry's constant via Markov's summation", apery_m())

# Apéry's constant via Wedeniwski's summation
def apery_w(nterms=20):
    total = Decimal('1') / Decimal('24') * sum(
        (Decimal('1') if k % 2 == 0 else Decimal('-1')) *
        my_sympy_format_to_decimal(factorial(2 * k + 1)) ** 3 *
        my_sympy_format_to_decimal(factorial(2 * k)) ** 3 *
        my_sympy_format_to_decimal(factorial(k)) ** 3 *
        (Decimal('126392') * Decimal(k) ** 5 +
         Decimal('412708') * Decimal(k) ** 4 +
         Decimal('531578') * Decimal(k) ** 3 +
         Decimal('336367') * Decimal(k) ** 2 +
         Decimal('104000') * Decimal(k) +
         Decimal('12463')) /
        (my_sympy_format_to_decimal(factorial(3 * k + 2)) * my_sympy_format_to_decimal(factorial(4 * k + 3)) ** 3)
        for k in range(0, nterms + 1)
    )
    return total
print_apery_constant("Apéry's constant via Wedeniwski's summation", apery_w())
