#include <print>
#include <random>

#include <cmath>
#include <cstddef>

[[nodiscard]] double monte_carlo_pi(std::size_t samples) noexcept {
    std::mt19937_64 eng{ std::random_device{}() }; // consider using better seeding
    std::uniform_real_distribution<double> dst{};
    std::size_t hits = 0;
    for (std::size_t i = 0; i < samples; ++i) {
        if (std::hypot(dst(eng), dst(eng)) <= 1.0) ++hits;
    }
    return (static_cast<double>(hits) / samples) * 4;
}

int main() {
    // using C++23's `std::println` in order to make printing `double`s accurate;
    // this would also work with the classic `std::cout`
    std::println("{}", monte_carlo_pi(10));
    std::println("{}", monte_carlo_pi(100));
    std::println("{}", monte_carlo_pi(1000));
    std::println("{}", monte_carlo_pi(10'000));
    std::println("{}", monte_carlo_pi(100'000));
    std::println("{}", monte_carlo_pi(1'000'000));
    std::println("{}", monte_carlo_pi(10'000'000));
    std::println("{}", monte_carlo_pi(100'000'000));
    std::println("{}", monte_carlo_pi(1'000'000'000));
}
