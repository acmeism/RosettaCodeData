def compute_phi(n_max):
    """
    Computes Euler's totient function (phi) for all integers up to n_max.
    """
    phi = list(range(n_max + 1))  # Initialize phi[i] = i
    for p in range(2, n_max + 1):
        if phi[p] == p:  # p is a prime number
            for multiple in range(p, n_max + 1, p):
                phi[multiple] -= phi[multiple] // p
    return phi


def compute_cumulative_phi(phi):
    """
    Computes the cumulative sum of phi values up to each n.
    """
    n_max = len(phi) - 1
    sum_phi = [0] * (n_max + 1)
    for i in range(1, n_max + 1):
        sum_phi[i] = sum_phi[i - 1] + phi[i]
    return sum_phi


def compute_a(n):
    """
    Computes the sequence a(n) for n from 1 to n_max.
    """
    a = []
    sum_phi = compute_cumulative_phi(compute_phi(n))
    for n in range(1, n + 1):
        total_pairs = n * (n - 1) // 2  # Total possible pairs (x, y) with 1 < x < y <= n
        a_n = total_pairs + 1 - sum_phi[n]  # Apply the formula
        a.append(a_n)
    return a


if __name__ == "__main__":
    max_n = 1000000
    a_sequence = compute_a(max_n)

    # Extract and print the first 100 terms
    first_100_terms = a_sequence[:100]
    print("First 100 terms of the sequence:")
    print(first_100_terms)

    a_1000 = a_sequence[999]  # Indexing starts from 0
    print("a(1000):", a_1000)

    a_10000 = a_sequence[9999]
    print("a(10000):", a_10000)

    a_100000 = a_sequence[99999]
    print("a(100000):", a_100000)

    a_1000000 = a_sequence[999999]
    print("a(1000000):", a_1000000)
