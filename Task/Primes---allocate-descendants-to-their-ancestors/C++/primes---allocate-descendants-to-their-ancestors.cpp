#include <algorithm>
#include <iostream>
#include <vector>

typedef unsigned long long integer;

// returns all ancestors of n. n is not its own ancestor.
std::vector<integer> get_ancestors(const std::vector<integer>& ancestor, integer n) {
    std::vector<integer> result;
    for (integer a = ancestor[n]; a != 0 && a != n; ) {
        n = a;
        a = ancestor[n];
        result.push_back(n);
    }
    return result;
}

void print_vector(const std::vector<integer>& vec) {
    if (vec.empty()) {
        std::cout << "none\n";
        return;
    }
    auto i = vec.begin();
    std::cout << *i++;
    for (; i != vec.end(); ++i)
        std::cout << ", " << *i;
    std::cout << '\n';
}

bool is_prime(integer n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    for (integer p = 3; p * p <= n; p += 2) {
        if (n % p == 0)
            return false;
    }
    return true;
}

int main(int argc, char** argv) {
    const size_t limit = 100;

    std::vector<integer> ancestor(limit, 0);
    std::vector<std::vector<integer>> descendants(limit);

    for (size_t prime = 0; prime < limit; ++prime) {
        if (!is_prime(prime))
            continue;
        descendants[prime].push_back(prime);
        for (size_t i = 0; i + prime < limit; ++i) {
            integer s = i + prime;
            for (integer n : descendants[i]) {
                integer prod = n * prime;
                descendants[s].push_back(prod);
                if (prod < limit)
                    ancestor[prod] = s;
            }
        }
    }

    // print the results
    size_t total_descendants = 0;
    for (integer i = 1; i < limit; ++i) {
        std::vector<integer> ancestors(get_ancestors(ancestor, i));
        std::cout << "[" << i << "] Level: " << ancestors.size() << '\n';
        std::cout << "Ancestors: ";
        std::sort(ancestors.begin(), ancestors.end());
        print_vector(ancestors);

        std::cout << "Descendants: ";
        std::vector<integer>& desc = descendants[i];
        if (!desc.empty()) {
            std::sort(desc.begin(), desc.end());
            if (desc[0] == i)
                desc.erase(desc.begin());
        }
        std::cout << desc.size() << '\n';
        total_descendants += desc.size();
        if (!desc.empty())
            print_vector(desc);
        std::cout << '\n';
    }
    std::cout << "Total descendants: " << total_descendants << '\n';
    return 0;
}
