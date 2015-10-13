#include <iostream>
#include <stdlib.h>

class trit {
public:
    static const trit False, Maybe, True;

    trit operator !() const {
        return static_cast<Value>(-value);
    }

    trit operator &&(const trit &b) const {
        return (value < b.value) ? value : b.value;
    }

    trit operator ||(const trit &b) const {
        return (value > b.value) ? value : b.value;
    }

    trit operator >>(const trit &b) const {
        return -value > b.value ? static_cast<Value>(-value) : b.value;
    }

    trit operator ==(const trit &b) const {
        return static_cast<Value>(value * b.value);
    }

    char chr() const {
        return "F?T"[value + 1];
    }

protected:
    typedef enum { FALSE=-1, MAYBE, TRUE } Value;

    Value value;

    trit(const Value value) : value(value) { }
};

std::ostream& operator<<(std::ostream &os, const trit &t)
{
    os << t.chr();
    return os;
}

const trit trit::False = trit(trit::FALSE);
const trit trit::Maybe = trit(trit::MAYBE);
const trit trit::True = trit(trit::TRUE);

int main(int, char**) {
    const trit trits[3] = { trit::True, trit::Maybe, trit::False };

#define for_each(name) \
    for (size_t name=0; name<3; ++name)

#define show_op(op) \
    std::cout << std::endl << #op << " "; \
    for_each(a) std::cout << ' ' << trits[a]; \
    std::cout << std::endl << "  -------"; \
    for_each(a) { \
        std::cout << std::endl << trits[a] << " |"; \
        for_each(b) std::cout << ' ' << (trits[a] op trits[b]); \
    } \
    std::cout << std::endl;

    std::cout << "! ----" << std::endl;
    for_each(a) std::cout << trits[a] << " | " << !trits[a] << std::endl;

    show_op(&&);
    show_op(||);
    show_op(>>);
    show_op(==);
    return EXIT_SUCCESS;
}
