#include <iostream>
#include <type_traits>

template<size_t I, int... Args>
struct find_impl;

template<int A, int... Args>
struct find_impl<0, A, Args...> {
    using type = std::integral_constant<int, A>;
};

template<int A, int B, int... Args>
struct find_impl<0, A, B, Args...> {
    using type = std::integral_constant<int, A>;
};

template<size_t I, int A, int B, int... Args>
struct find_impl<I, A, B, Args...> {
    using type = typename find_impl<I-1, B, Args...>::type;
};

namespace detail {
template<typename, typename>
struct append_sequence
{};

template<typename T, typename... Ts>
struct append_sequence<T, std::tuple<Ts...>> {
    using type = std::tuple<Ts..., T>;
};

template<typename... Ts>
struct reverse_sequence {
    using type = std::tuple<>;
};

template<typename T, typename... Ts>
struct reverse_sequence<T, Ts...> {
    using type = typename append_sequence<
                            T,
                            typename reverse_sequence<Ts...>::type
                        >::type;
};
}

template<size_t I>
using rule3 = typename find_impl<I, 0, 2, 4, 6, 8, 1, 3, 5, 7, 9>::type;

template<int A, char C, bool dgt>
struct calc
    : std::integral_constant<int, A + C - '0'>
{};

template<int A, char C>
struct calc<A, C, false>
    : std::integral_constant<int, A + rule3<C - '0'>::type::value>
{};

template<typename Acc, bool Dgt, char...>
struct luhn_impl;

template<typename Acc, bool Dgt, char A, char... Args>
struct luhn_impl<Acc, Dgt, A, Args...> {
    using type = typename calc<Acc::value, A, Dgt>::type;
};

template<typename Acc, bool Dgt, char A, char B, char... Args>
struct luhn_impl<Acc, Dgt, A, B, Args...> {
    using type =
        typename luhn_impl<typename calc<Acc::value, A, Dgt>::type, !Dgt, B, Args...>::type;
};

template<typename>
struct luhn;

template<typename... Args>
struct luhn<std::tuple<Args...>> {
    using type = typename luhn_impl<std::integral_constant<int, 0>, true, Args::value...>::type;
    constexpr static bool result = (type::value % 10) == 0;
};

template<char... Args>
bool operator "" _luhn() {
    return luhn<typename detail::reverse_sequence<std::integral_constant<char, Args>...>::type>::result;
}

int main() {
    std::cout << std::boolalpha;
    std::cout << 49927398716_luhn << std::endl;
    std::cout << 49927398717_luhn << std::endl;
    std::cout << 1234567812345678_luhn << std::endl;
    std::cout << 1234567812345670_luhn << std::endl;
    return 0;
}
