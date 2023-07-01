#include <array>
#include <iostream>
#include <vector>
#include <boost/circular_buffer.hpp>
#include "prime_sieve.hpp"

int main() {
    using std::cout;
    using std::vector;
    using boost::circular_buffer;
    using group_buffer = circular_buffer<vector<int>>;

    const int max = 1000035;
    const int max_group_size = 5;
    const int diff = 6;
    const int array_size = max + diff;
    const int max_groups = 5;
    const int max_unsexy = 10;

    // Use Sieve of Eratosthenes to find prime numbers up to max
    prime_sieve sieve(array_size);

    std::array<int, max_group_size> group_count{0};
    vector<group_buffer> groups(max_group_size, group_buffer(max_groups));
    int unsexy_count = 0;
    circular_buffer<int> unsexy_primes(max_unsexy);
    vector<int> group;

    for (int p = 2; p < max; ++p) {
        if (!sieve.is_prime(p))
            continue;
        if (!sieve.is_prime(p + diff) && (p - diff < 2 || !sieve.is_prime(p - diff))) {
            // if p + diff and p - diff aren't prime then p can't be sexy
            ++unsexy_count;
            unsexy_primes.push_back(p);
        } else {
            // find the groups of sexy primes that begin with p
            group.clear();
            group.push_back(p);
            for (int group_size = 1; group_size < max_group_size; group_size++) {
                int next_p = p + group_size * diff;
                if (next_p >= max || !sieve.is_prime(next_p))
                    break;
                group.push_back(next_p);
                ++group_count[group_size];
                groups[group_size].push_back(group);
            }
        }
    }

    for (int size = 1; size < max_group_size; ++size) {
        cout << "number of groups of size " << size + 1 << " is " << group_count[size] << '\n';
        cout << "last " << groups[size].size() << " groups of size " << size + 1 << ":";
        for (const vector<int>& group : groups[size]) {
            cout << " (";
            for (size_t i = 0; i < group.size(); ++i) {
                if (i > 0)
                    cout << ' ';
                cout << group[i];
            }
            cout << ")";
        }
        cout << "\n\n";
    }
    cout << "number of unsexy primes is " << unsexy_count << '\n';
    cout << "last " << unsexy_primes.size() << " unsexy primes:";
    for (int prime : unsexy_primes)
        cout << ' ' << prime;
    cout << '\n';
    return 0;
}
