#include <array>
#include <cstdint>
#include <iostream>
#include <memory>
#include <numeric>

template <size_t n, typename T> static constexpr T power(T base) {
  if constexpr (n == 0)
    return 1;
  else if constexpr (n == 1)
    return base;
  else if constexpr (n & 1)
    return power<n / 2, T>(base * base) * base;
  else
    return power<n / 2, T>(base * base);
}

static constexpr int count = 1024;
static constexpr uint64_t count_diff = []() {
  // finds something that looks kinda sorta prime.
  const uint64_t coprime_to_this = 2llu * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 37 * 41 * 43 * 59;
  // we make this oversized to reduce collisions and just hope it fits in cache.
  uint64_t guess = 7 * count * count;
  for (; std::gcd(guess, coprime_to_this) > 1; ++guess)
    ;
  return guess;
}();

static constexpr int fast_integer_root5(const double x) {
  constexpr uint64_t magic = 3685583637919522816llu;
  uint64_t x_i = std::bit_cast<uint64_t>(x);
  x_i /= 5;
  x_i += magic;
  const double x_f = std::bit_cast<double>(x_i);
  const double x5 = power<5>(x_f);
  return x_f * ((x - x5) / (3 * x5 + 2 * x)) + (x_f + .5);
}

static constexpr uint64_t hash(uint64_t h) { return h % count_diff; }

void euler() {
  std::array<int64_t, count> pow5;
  for (int64_t i = 0; i < count; i++)
    pow5[i] = power<5>(i);

  // build hash table
  constexpr int oversize_fudge = 8;
  std::unique_ptr<int16_t[]> differences = std::make_unique<int16_t[]>(count_diff + oversize_fudge);
  std::fill(differences.get(), differences.get() + count_diff + oversize_fudge, 0);
  for (int64_t n = 4; n < count; n++)
    for (int64_t d = 3; d < n; d++) {
      uint64_t h = hash(pow5[n] - pow5[d]);
      for (; differences[h]; ++h)
        if (h >= count_diff + oversize_fudge - 2) {
          std::cerr << "too many collisions; increase fudge factor or hash table size\n";
          return;
        }
      differences[h] = d;
      if (h >= count_diff)
        differences[h - count_diff] = d;
    }

  // brute force a,b,c
  const int a_max = fast_integer_root5(.25 * pow5.back());
  for (int a = 0; a <= a_max; a++) {
    const int b_max = fast_integer_root5((1.0 / 3.0) * (pow5.back() - pow5[a]));
    for (int b = a; b <= b_max; b++) {
      const int64_t a5_p_b5 = pow5[a] + pow5[b];
      const int c_max = fast_integer_root5(.5 * (pow5.back() - a5_p_b5));
      for (int c = b; c <= c_max; c++) {
        // lookup d in hash table
        const int64_t n5_minus_d5 = a5_p_b5 + pow5[c];
	    //this loop is O(1)
	    for (uint64_t h = hash(n5_minus_d5); differences[h]; ++h) {
          if (const int d = differences[h]; d >= c)
            // calculate n from d
            if (const int n = fast_integer_root5(n5_minus_d5 + pow5[d]);
                // check whether this is a solution
                n < count && n5_minus_d5 == pow5[n] - pow5[d] && d != n)
              std::cout << a << "^5 + " << b << "^5 + " << c << "^5 + " << d << "^5 = " << n << "^5\t"
                        << pow5[a] + pow5[b] + pow5[c] + pow5[d] << " = " << pow5[n] << '\n';
        }
      }
    }
  }
}

int main() {
  std::ios::sync_with_stdio(false);
  euler();
  return 0;
}
