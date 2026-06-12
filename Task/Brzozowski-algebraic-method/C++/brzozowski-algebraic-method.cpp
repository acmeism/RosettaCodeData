#include <iostream>
#include <string>
#include <vector>
#include <memory>

class RegularExpression {
public:
    virtual ~RegularExpression() {}
    virtual std::shared_ptr<RegularExpression> simplify() = 0;
    virtual std::string sprintRE() = 0;
    virtual bool equals(std::shared_ptr<RegularExpression> other) = 0;
};

class EmptyExpr : public RegularExpression {
public:
    std::shared_ptr<RegularExpression> simplify() override {
        return std::make_shared<EmptyExpr>();
    }
    std::string sprintRE() override {
        return "0";
    }
    bool equals(std::shared_ptr<RegularExpression> other) override {
        return dynamic_cast<EmptyExpr*>(other.get()) != nullptr;
    }
};

class EpsilonExpr : public RegularExpression {
public:
    std::shared_ptr<RegularExpression> simplify() override {
        return std::make_shared<EpsilonExpr>();
    }
    std::string sprintRE() override {
        return "1";
    }
    bool equals(std::shared_ptr<RegularExpression> other) override {
        return dynamic_cast<EpsilonExpr*>(other.get()) != nullptr;
    }
};

class CarExpr : public RegularExpression {
public:
    char c;
    CarExpr(char c) : c(c) {}
    std::shared_ptr<RegularExpression> simplify() override {
        return std::make_shared<CarExpr>(c);
    }
    std::string sprintRE() override {
        return std::string(1, c);
    }
    bool equals(std::shared_ptr<RegularExpression> other) override {
        CarExpr* o = dynamic_cast<CarExpr*>(other.get());
        return o != nullptr && c == o->c;
    }
};

class UnionExpr : public RegularExpression {
public:
    std::shared_ptr<RegularExpression> e, f;
    UnionExpr(std::shared_ptr<RegularExpression> e, std::shared_ptr<RegularExpression> f) : e(e), f(f) {}
    std::shared_ptr<RegularExpression> simplify() override;
    std::string sprintRE() override {
        return e->sprintRE() + "+" + f->sprintRE();
    }
    bool equals(std::shared_ptr<RegularExpression> other) override {
        UnionExpr* o = dynamic_cast<UnionExpr*>(other.get());
        if (o != nullptr) {
            // Since Union is commutative, check both orders
            return (e->equals(o->e) && f->equals(o->f)) || (e->equals(o->f) && f->equals(o->e));
        }
        return false;
    }
};

class ConcatExpr : public RegularExpression {
public:
    std::shared_ptr<RegularExpression> e, f;
    ConcatExpr(std::shared_ptr<RegularExpression> e, std::shared_ptr<RegularExpression> f) : e(e), f(f) {}
    std::shared_ptr<RegularExpression> simplify() override;
    std::string sprintRE() override {
        return "(" + e->sprintRE() + ")(" + f->sprintRE() + ")";
    }
    bool equals(std::shared_ptr<RegularExpression> other) override {
        ConcatExpr* o = dynamic_cast<ConcatExpr*>(other.get());
        if (o != nullptr) {
            return e->equals(o->e) && f->equals(o->f);
        }
        return false;
    }
};

class StarExpr : public RegularExpression {
public:
    std::shared_ptr<RegularExpression> e;
    StarExpr(std::shared_ptr<RegularExpression> e) : e(e) {}
    std::shared_ptr<RegularExpression> simplify() override;
    std::string sprintRE() override {
        return "(" + e->sprintRE() + ")*";
    }
    bool equals(std::shared_ptr<RegularExpression> other) override {
        StarExpr* o = dynamic_cast<StarExpr*>(other.get());
        if (o != nullptr) {
            return e->equals(o->e);
        }
        return false;
    }
};

std::shared_ptr<RegularExpression> UnionExpr::simplify() {
    auto se = e->simplify();
    auto sf = f->simplify();
    if (se->equals(sf)) {
        return se;
    } else if (dynamic_cast<EmptyExpr*>(se.get()) != nullptr) {
        return sf;
    } else if (dynamic_cast<EmptyExpr*>(sf.get()) != nullptr) {
        return se;
    } else {
        return std::make_shared<UnionExpr>(se, sf);
    }
}

std::shared_ptr<RegularExpression> ConcatExpr::simplify() {
    auto se = e->simplify();
    auto sf = f->simplify();
    if (dynamic_cast<EpsilonExpr*>(se.get()) != nullptr) {
        return sf;
    } else if (dynamic_cast<EpsilonExpr*>(sf.get()) != nullptr) {
        return se;
    } else if (dynamic_cast<EmptyExpr*>(se.get()) != nullptr || dynamic_cast<EmptyExpr*>(sf.get()) != nullptr) {
        return std::make_shared<EmptyExpr>();
    } else {
        return std::make_shared<ConcatExpr>(se, sf);
    }
}

std::shared_ptr<RegularExpression> StarExpr::simplify() {
    auto se = e->simplify();
    if (dynamic_cast<EmptyExpr*>(se.get()) != nullptr || dynamic_cast<EpsilonExpr*>(se.get()) != nullptr) {
        return std::make_shared<EpsilonExpr>();
    } else {
        return std::make_shared<StarExpr>(se);
    }
}

std::shared_ptr<RegularExpression> recursiveSimplify(std::shared_ptr<RegularExpression> expr, int depth) {
    if (depth > 200) {
        return expr;
    } else {
        auto simplified = expr->simplify();
        if (simplified->equals(expr)) {
            return simplified;
        } else {
            return recursiveSimplify(simplified, depth + 1);
        }
    }
}

std::shared_ptr<RegularExpression> brzozowski(std::vector<std::vector<std::shared_ptr<RegularExpression>>>& a, std::vector<std::shared_ptr<RegularExpression>>& b) {
    int m = a.size();
    auto tempA = a;
    auto tempB = b;
    for (int n = m - 1; n >= 0; --n) {
        tempB[n] = std::make_shared<ConcatExpr>(std::make_shared<StarExpr>(tempA[n][n]), tempB[n]);
        for (int j = 0; j < n; ++j) {
            tempA[n][j] = std::make_shared<ConcatExpr>(std::make_shared<StarExpr>(tempA[n][n]), tempA[n][j]);
        }
        for (int i = 0; i < n; ++i) {
            tempB[i] = std::make_shared<UnionExpr>(tempB[i], std::make_shared<ConcatExpr>(tempA[i][n], tempB[n]));
            for (int j = 0; j < n; ++j) {
                tempA[i][j] = std::make_shared<UnionExpr>(tempA[i][j], std::make_shared<ConcatExpr>(tempA[i][n], tempA[n][j]));
            }
        }
        for (int i = 0; i < n; ++i) {
            tempA[i][n] = std::make_shared<EmptyExpr>();
        }
    }
    return tempB[0];
}

int main() {
    // Define the NFA transition matrix a
    std::vector<std::vector<std::shared_ptr<RegularExpression>>> a(3, std::vector<std::shared_ptr<RegularExpression>>(3));
    a[0][0] = std::make_shared<EmptyExpr>();
    a[0][1] = std::make_shared<CarExpr>('a');
    a[0][2] = std::make_shared<CarExpr>('b');

    a[1][0] = std::make_shared<CarExpr>('b');
    a[1][1] = std::make_shared<EmptyExpr>();
    a[1][2] = std::make_shared<CarExpr>('a');

    a[2][0] = std::make_shared<CarExpr>('a');
    a[2][1] = std::make_shared<CarExpr>('b');
    a[2][2] = std::make_shared<EmptyExpr>();

    // Define the initial state vector b
    std::vector<std::shared_ptr<RegularExpression>> b(3);
    b[0] = std::make_shared<EpsilonExpr>();
    b[1] = std::make_shared<EmptyExpr>();
    b[2] = std::make_shared<EmptyExpr>();

    // Apply Brzozowski's algorithm
    auto dfaExpr = brzozowski(a, b);

    // Print the regular expression
    std::cout << dfaExpr->sprintRE() << "\n\n";

    // Apply recursive simplification
    auto simplifiedDFA = recursiveSimplify(dfaExpr, 0);
    std::cout << simplifiedDFA->sprintRE() << std::endl;

    return 0;
}
