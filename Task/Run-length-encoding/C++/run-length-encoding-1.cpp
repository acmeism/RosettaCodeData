#include <algorithm>
#include <array>
#include <iterator>
#include <limits>
#include <tuple>

namespace detail_ {

// For constexpr digit<->number conversions.
constexpr auto digits = std::array{'0','1','2','3','4','5','6','7','8','9'};

// Helper function to encode a run-length.
template <typename OutputIterator>
constexpr auto encode_run_length(std::size_t n, OutputIterator out)
{
    constexpr auto base = digits.size();

    // Determine the number of digits needed.
    auto const num_digits = [base](auto n)
    {
        auto d = std::size_t{1};
        while ((n /= digits.size()))
            ++d;
        return d;
    }(n);

    // Helper lambda to raise the base to an integer power.
    auto base_power = [base](auto n)
    {
        auto res = decltype(base){1};
        for (auto i = decltype(n){1}; i < n; ++i)
            res *= base;
        return res;
    };

    // From the most significant digit to the least, output the digit.
    for (auto i = decltype(num_digits){0}; i < num_digits; ++i)
        *out++ = digits[(n / base_power(num_digits - i)) % base];

    return out;
}

// Helper function to decode a run-length.
// As of C++20, this can be constexpr, because std::find() is constexpr.
// Before C++20, it can be constexpr by emulating std::find().
template <typename InputIterator>
auto decode_run_length(InputIterator first, InputIterator last)
{
    auto count = std::size_t{0};

    while (first != last)
    {
        // If the next input character is not a digit, we're done.
        auto const p = std::find(digits.begin(), digits.end(), *first);
        if (p == digits.end())
            break;

        // Convert the digit to a number, and append it to the size.
        count *= digits.size();
        count += std::distance(digits.begin(), p);

        // Move on to the next input character.
        ++first;
    }

    return std::tuple{count, first};
}

} // namespace detail_

template <typename InputIterator, typename OutputIterator>
constexpr auto encode(InputIterator first, InputIterator last, OutputIterator out)
{
    while (first != last)
    {
        // Read the next value.
        auto const value = *first++;

        // Increase the count as long as the next value is the same.
        auto count = std::size_t{1};
        while (first != last && *first == value)
        {
            ++count;
            ++first;
        }

        // Write the value and its run length.
        out = detail_::encode_run_length(count, out);
        *out++ = value;
    }

    return out;
}

// As of C++20, this can be constexpr, because std::find() and
// std::fill_n() are constexpr (and decode_run_length() can be
// constexpr, too).
// Before C++20, it can be constexpr by emulating std::find() and
// std::fill_n().
template <typename InputIterator, typename OutputIterator>
auto decode(InputIterator first, InputIterator last, OutputIterator out)
{
    while (first != last)
    {
        using detail_::digits;

        // Assume a run-length of 1, then try to decode the actual
        // run-length, if any.
        auto count = std::size_t{1};
        if (std::find(digits.begin(), digits.end(), *first) != digits.end())
            std::tie(count, first) = detail_::decode_run_length(first, last);

        // Write the run.
        out = std::fill_n(out, count, *first++);
    }

    return out;
}

template <typename Range, typename OutputIterator>
constexpr auto encode(Range&& range, OutputIterator out)
{
    using std::begin;
    using std::end;

    return encode(begin(range), end(range), out);
}

template <typename Range, typename OutputIterator>
auto decode(Range&& range, OutputIterator out)
{
    using std::begin;
    using std::end;

    return decode(begin(range), end(range), out);
}

// Sample application and checking ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include <iostream>
#include <string_view>

int main()
{
    using namespace std::literals;

    constexpr auto test_string = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"sv;

    std::cout << "Input:  \"" << test_string << "\"\n";
    std::cout << "Output: \"";
    // No need for a temporary string - can encode directly to cout.
    encode(test_string, std::ostreambuf_iterator<char>{std::cout});
    std::cout << "\"\n";

    auto encoded_str = std::string{};
    auto decoded_str = std::string{};
    encode(test_string, std::back_inserter(encoded_str));
    decode(encoded_str, std::back_inserter(decoded_str));

    std::cout.setf(std::cout.boolalpha);
    std::cout << "Round trip works: " << (test_string == decoded_str) << '\n';
}
