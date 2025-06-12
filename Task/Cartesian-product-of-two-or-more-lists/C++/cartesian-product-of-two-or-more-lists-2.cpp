#include <array>
#include <print>
#include <ranges>
#include <tuple>

template <class T, std::size_t N>
using a = std::array<T, N>;

template <class... Ts>
using t = std::tuple<Ts...>;

template <class... Ts>
constexpr auto product(const t<Ts...>& inputs) {
    const auto rng = std::apply(std::views::cartesian_product, inputs);

    std::println("{}", rng);
}

int main() {
    // The size of each list of arrays needs to be known at compile-time in order to use `cartesian_product()`
    // However, each array is a different size, thus a distinct type, so we use a tuple to hold all of them
    // The brace-initialized constructor cannot deduce the type of empty array, so we spell them out manually
    constexpr auto prods = t{
        t{a{1, 2}, a{3, 4}},
        t{a{3, 4}, a{1, 2}},
        t{a{1, 2}, a<int, 0>{}},
        t{a<int, 0>{}, a{1, 2}},
        t{a{1776, 1789}, a{7, 12}, a{4, 14, 23}, a{0, 1}},
        t{a{1, 2, 3}, a{30}, a{500, 100}},
        t{a{1, 2, 3}, a<int, 0>{}, a{500, 100}}
    };

    std::apply([](const auto &... test_cases) {
        (product(test_cases), ...);
    }, prods);
}
