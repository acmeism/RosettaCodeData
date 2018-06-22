enum Color { R, B };
template<Color, class, auto, class> struct T;
struct E;

template<Color col, class a, auto x, class b> struct balance {
    using type = T<col, a, x, b>;
};
template<class a, auto x, class b, auto y, class c, auto z, class d>
struct balance<B, T<R, T<R, a, x, b>, y, c>, z, d> {
    using type = T<R, T<B, a, x, b>, y, T<B, c, z, d>>;
};
template<class a, auto x, class b, auto y, class c, auto z, class d>
struct balance<B, T<R, a, x, T<R, b, y, c>>, z, d> {
    using type = T<R, T<B, a, x, b>, y, T<B, c, z, d>>;
};
template<class a, auto x, class b, auto y, class c, auto z, class d>
struct balance<B, a, x, T<R, T<R, b, y, c>, z, d>> {
    using type = T<R, T<B, a, x, b>, y, T<B, c, z, d>>;
};
template<class a, auto x, class b, auto y, class c, auto z, class d>
struct balance<B, a, x, T<R, b, y, T<R, c, z, d>>> {
    using type = T<R, T<B, a, x, b>, y, T<B, c, z, d>>;
};

template<auto x, class s> struct insert {
    template<class, class = void> struct ins;
    template<class _> struct ins<E, _> { using type = T<R, E, x, E>; };
    template<Color col, class a, auto y, class b> struct ins<T<col, a, y, b>> {
        template<int, class = void> struct cond;
        template<class _> struct cond<-1, _> : balance<col, typename ins<a>::type, y, b> {};
        template<class _> struct cond<1, _> : balance<col, a, y, typename ins<b>::type> {};
        template<class _> struct cond<0, _> { using type = T<col, a, y, b>; };
        using type = typename cond<x < y ? -1 : y < x ? 1 : 0>::type;
    };
    template<class> struct repaint;
    template<Color col, class a, auto y, class b>
    struct repaint<T<col, a, y, b>> { using type = T<B, a, y, b>; };
    using type = typename repaint<typename ins<s>::type>::type;
};
template<auto x, class s> using insert_t = typename insert<x, s>::type;

template<class> void print();
int main() {
    print<insert_t<1, insert_t<2, insert_t<0, insert_t<4, E>>>>>();
}
