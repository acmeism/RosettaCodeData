OMEGA_CONST = -0.5 + 0.5 * (3 ** 0.5) * 1j

def is_prime(n: int) -> bool:
    if n < 2:
        return False

    if n in [2, 3, 5]:
        return True

    for i in range(2, int(n ** 0.5) + 1):
        if n % i == 0:
            return False

    return True

class Eisentein:
    def __init__(self, re: int, im: int) -> None:
        self.re: int = re
        self.im: int = im
        self.va: float = re + im * OMEGA_CONST

    def real(self) -> float:
        return self.va.real

    def imag(self) -> float:
        return self.va.imag

    def norm(self) -> int:
        return self.re * self.re - self.re * self.im + self.im * self.im

    def is_prime(self) -> bool:
        if self.re == 0 or self.im == 0 or self.re == self.im:
            _temp = max(abs(self.re), abs(self.im))
            return is_prime(_temp) and (_temp % 3 == 2)

        else:
            return is_prime(self.norm())

    def __str__(self) -> str:
        sgn = (lambda im: "+" if im >= 0 else "-")(self.im)
        return f"{self.real():7.4f} {sgn} {abs(self.imag()):6.4f}ω"

def main() -> None:
    eisentein_primes: list[Eisentein] = []

    for i in range(-100, 101):
        for j in range(-100, 101):
            e = Eisentein(i, j)
            if Eisentein.is_prime(e):
                eisentein_primes += [e]

    eisentein_primes = sorted(
        eisentein_primes, key = lambda x: (x.norm(), x.im, x.re)
    )

    print("First 100 Eisentein primes near 0:")
    for i in range(0, 100):
        print(eisentein_primes[i], end = "\n" if i % 4 == 3 else "  ")

if __name__ == "__main__":
    main()
