#include <algorithm>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& vec) {
   std::cout << "[";
   for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
      std::cout << vec[i] << ", ";
   }
   std::cout << vec.back() << "]";
}

template <typename T>
std::vector<std::vector<T>> permutations(const std::vector<T>& vec) {
   std::vector<std::vector<T>> perms{ };
   std::vector<T> copy(vec);

   do {
        perms.emplace_back(copy);
    } while ( std::next_permutation(copy.begin(), copy.end()) );
   return perms;
}

template <typename T>
std::vector<std::vector<T>> combinations(const std::vector<T>& vec, const uint32_t& k) {
   std::vector<std::vector<T>> combs{ };
    std::vector bitmask(k, 1);     // k leading 1's
    bitmask.resize(vec.size(), 0); // ( vec.size() - k ) trailing 0's

    do {
      std::vector<T> next_vector{ };
        for ( uint32_t i = 0; i < vec.size(); ++i ) {
            if ( bitmask[i] )  {
               next_vector.emplace_back(vec[i]);
            }
        }
        combs.emplace_back(next_vector);
    } while ( std::prev_permutation(bitmask.begin(), bitmask.end()) );
    return combs;
}

template <typename T>
std::vector<std::vector<T>> all_combinations(const std::vector<T>& vec) {
   std::vector<std::vector<T>> all_combinations{ };
   for ( uint32_t i = 1; i <= vec.size(); ++i ) {
      std::vector<std::vector<T>> combs = combinations(vec, i);
      all_combinations.insert(all_combinations.end(), combs.begin(), combs.end());
   }
   return all_combinations;
}

void count_coins(const std::vector<uint32_t>& coins, const uint32_t& target) {
   std::cout << "Coins are "; print_vector(coins);  std::cout << ", target sum is " << target << std::endl;
   uint32_t comb_count = 0;
   uint32_t perm_count = 0;
   for ( std::vector<uint32_t> combination : all_combinations(coins) ) {
      const uint32_t sum = std::accumulate(combination.begin(), combination.end(), 0);
      if ( sum == target ) {
         comb_count += 1;
         if ( target <= 6 ) {
            print_vector(combination); std::cout << " sums to " << target << std::endl;
         }
         for ( std::vector<uint32_t> permutation : permutations(combination) ) {
            if ( target <= 6 ) {
               std::cout << "    permutation: "; print_vector(permutation); std::cout << std::endl;
            }
            perm_count += 1;
         }
      }
   }

   std::cout << "Combinations: " << comb_count << ", Permutations: " << perm_count << std::endl;
    std::cout << std::endl;
}

int main() {
   count_coins({ 1, 2, 3, 4, 5 }, 6);
   count_coins({ 1, 1, 2, 3, 3, 4, 5 }, 6);
   count_coins({ 1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100 }, 40);
}
