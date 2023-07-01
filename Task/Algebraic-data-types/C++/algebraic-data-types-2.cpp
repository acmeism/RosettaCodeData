#include <memory>
#include <variant>

template<class... Ts> struct overloaded : Ts... { using Ts::operator()...; };
template<class... Ts> overloaded(Ts...) -> overloaded<Ts...>;

enum Color { R, B };
using E = std::monostate;
template<class, Color> struct Node;
template<class T, Color C> using Ptr = std::unique_ptr<Node<T, C>>;
template<class T> using Tree = std::variant<E, Ptr<T, R>, Ptr<T, B>>;
template<class T, Color Col> struct Node {
    static constexpr auto C = Col;
    Tree<T> left;
    T value;
    Tree<T> right;
};
template<Color C, class A, class T, class B> Tree<T> tree(A&& a, T& x, B&& b) {
    return Tree<T>{Ptr<T, C>{new Node<T, C>{std::move(a), std::move(x), std::move(b)}}};
}

template<class T> Tree<T> balance(Tree<T> s) {
    auto&& ll = [](Ptr<T, R>& s, Ptr<T, R>& t, auto&, Ptr<T, B>& u, auto&, auto&, auto&) {
        auto& [a, x, b] = *s;
        auto& [s_, y, c] = *t;
        auto& [t_, z, d] = *u;
        return tree<R>(tree<B>(a, x, b), y, tree<B>(c, z, d));
    };
    auto&& lr = [](auto&, Ptr<T, R>& s, Ptr<T, R>& t, Ptr<T, B>& u, auto&, auto&, auto&) {
        auto& [a, x, t_] = *s;
        auto& [b, y, c] = *t;
        auto& [s_, z, d] = *u;
        return tree<R>(tree<B>(a, x, b), y, tree<B>(c, z, d));
    };
    auto&& rl = [](auto&, auto&, auto&, Ptr<T, B>& s, Ptr<T, R>& t, Ptr<T, R>& u, auto&) {
        auto& [a, x, u_] = *s;
        auto& [b, y, c] = *t;
        auto& [t_, z, d] = *u;
        return tree<R>(tree<B>(a, x, b), y, tree<B>(c, z, d));
    };
    auto&& rr = [](auto&, auto&, auto&, Ptr<T, B>& s, auto&, Ptr<T, R>& t, Ptr<T, R>& u) {
        auto& [a, x, t_] = *s;
        auto& [b, y, u_] = *t;
        auto& [c, z, d] = *u;
        return tree<R>(tree<B>(a, x, b), y, tree<B>(c, z, d));
    };
    auto&& l = [](auto& s) -> Tree<T>& {
        return *std::visit(overloaded{[&](E) { return &s; }, [](auto& t) { return &t->left; }}, s);
    };
    auto&& r = [](auto& s) -> Tree<T>& {
        return *std::visit(overloaded{[&](E) { return &s; }, [](auto& t) { return &t->right; }}, s);
    };
    return std::visit([&](auto&... ss) -> Tree<T> {
        if constexpr (1 <
            std::is_invocable_v<decltype(ll), decltype(ss)...> +
            std::is_invocable_v<decltype(lr), decltype(ss)...> +
            std::is_invocable_v<decltype(rl), decltype(ss)...> +
            std::is_invocable_v<decltype(rr), decltype(ss)...>)
            throw std::logic_error{""};
        else
            return overloaded{ll, lr, rl, rr, [&](auto&... ss) { return std::move(s); }}(ss...);
    }, l(l(s)), l(s), r(l(s)), s, l(r(s)), r(s), r(r(s)));
}
template<class T> Tree<T> ins(T& x, Tree<T>& s) {
    return std::visit(overloaded{
        [&](E) -> Tree<T> { return tree<R>(s, x, s); },
        [&](auto& t) {
            auto& [a, y, b] = *t;
            static constexpr auto Col = std::remove_reference_t<decltype(*t)>::C;
            return x < y ? balance(tree<Col>(ins(x, a), y, b)) :
                y < x ? balance(tree<Col>(a, y, ins(x, b))) :
                std::move(s);
        },
    }, s);
}
template<class T> Tree<T> insert(T x, Tree<T> s) {
    return std::visit(overloaded{
        [](E) -> Tree<T> { throw std::logic_error{""}; },
        [](auto&& t) {
            auto& [a, y, b] = *t;
            return tree<B>(a, y, b);
        }
    }, ins(x, s));
}

#include <iostream>
template<class T> void print(Tree<T> const& s, int i = 0) {
    std::visit(overloaded{
        [](E) {},
        [&](auto& t) {
            auto& [a, y, b] = *t;
            print(a, i + 1);
            std::cout << std::string(i, ' ') << "RB"[t->C] << " " << y << "\n";
            print(b, i + 1);
        }
    }, s);
}
int main(int argc, char* argv[]) {
    auto t = Tree<std::string>{};
    for (auto i = 1; i != argc; ++i)
        t = insert(std::string{argv[i]}, std::move(t));
    print(t);
}
