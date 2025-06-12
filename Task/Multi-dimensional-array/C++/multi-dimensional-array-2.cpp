#include <array>     // array
#include <mdspan>    // mdspan
#include <numeric>   // ranges::iota
#include <print>     // println
#include <ranges>    // views::{cartesian_product, iota, take, transform}
#include <tuple>     // apply

using namespace std;

template <size_t... Extents>
    requires((Extents != dynamic_extent) && ...) && (sizeof...(Extents) < 10)
static consteval auto generate_array(extents<size_t, Extents...>) -> array<int, (Extents * ...)> {

    // Generate a sequence of numbers (0..size) to fit into the array
    auto ret = array<int, (Extents * ...)>{};
    ranges::iota(ret, 0);

    return ret;
}

// Given extents of size i, create right-index arrays of size i
// That is, a combination of indices that increment from the right-side first
template <size_t... Extents>
    requires((Extents != dynamic_extent) && ...)
static consteval auto right_indices(extents<size_t, Extents...>) {

    // Generate all combinations of (0..2, 0..3, 0..4, 0..5)
    constexpr auto index_ranges = views::cartesian_product(views::iota(size_t{}, Extents)...);

    // Convert tuple of numbers (a, b, c, d) to array of numbers [a, b, c, d]
    constexpr auto tuple_to_array = [](auto &&tuple) {
        return apply([](auto... elems) { return array{elems...}; }, tuple);
    };

    return index_ranges | views::transform(tuple_to_array);
}

int main() {
    // This type models the size of our backing array and the shape of the mdspan
    using exts = extents<size_t, 2, 3, 4, 5>;

    auto backing_array = generate_array(exts{});
    constexpr auto array_indices = right_indices(exts{});

    // mdspan accesses the underlying array in row-major ordering (std::layout_right) by default
    auto row_span = mdspan{backing_array.data(), exts{}};
    auto col_span = mdspan{backing_array.data(), layout_left::mapping{exts{}}};

    // print out the rank count and size of the underlying data structure
    println("row_span.rank() = {}", row_span.rank());
    println("row_span.size() = {}", row_span.size());

    // Display the size of each dimension
    for (auto &&i : views::iota(size_t{}, row_span.rank())) {
        println("row_span.extent({}) = {}, ", i, row_span.extent(i));
    }

    /// Add-assign a value using the multidimensional subscript operator
    row_span[0, 0, 0, 0] += 999;

    // We can't iterate through our dim_span directly, so we have to index through it instead
    // Here we demonstrate the ability to index into an mdspan with an array
    //
    // indexing out of bounds with [] is still undefined behavior
    // There is no .at() equivalent for throwing access

    println("\n======================== Row-major =======================\n");

    println("First 30 elements:\n{}",
            array_indices | views::take(30) |
                views::transform(
                    [&]<class T, size_t N>(array<T, N> &&idc) -> int { return row_span[idc]; }));

    println("\n=========== Column-major (right_array_indices) ===========\n");

    println("First 30 elements:\n{}",
            array_indices | views::take(30) |
                views::transform(
                    [&]<class T, size_t N>(array<T, N> &&idc) -> int { return col_span[idc]; }));
}
