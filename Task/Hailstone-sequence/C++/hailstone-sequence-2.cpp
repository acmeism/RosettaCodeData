#include <QDebug>
#include <QVector>

template <class T>
T hailstone(typename T::value_type n)
{
    T seq;
    for (seq << n; n != 1; seq << n) {
        n = (n&1) ? (3*n)+1 : n/2;
    }
    return seq;
}

template <class T>
T longest_hailstone_seq(typename T::value_type n)
{
    T maxSeq;
    for (; n > 0; --n) {
        const auto seq = hailstone<T>(n);
        if (seq.size() > maxSeq.size()) {
            maxSeq = seq;
        }
    }
    return maxSeq;
}

int main(int, char *[]) {
    const auto seq = hailstone<QVector<uint_fast16_t>>(27);
    qInfo() << "hailstone(27):";
    qInfo() << "  length:" << seq.size() << "elements";
    qInfo() << "  first 4 elements:" << seq.mid(0,4);
    qInfo() << "  last 4 elements:" << seq.mid(seq.size()-4);

    const auto max = longest_hailstone_seq<QVector<uint_fast32_t>>(100000);
    qInfo() << "longest sequence with starting element under 100000:";
    qInfo() << "  length:" << max.size() << "elements";
    qInfo() << "  starting element:" << max.first();
}
