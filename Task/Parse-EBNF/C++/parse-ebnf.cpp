#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include <variant>
#include <algorithm>
#include <optional>

class Token {
public:
    enum Type { CHAR, SEQUENCE, EOF_TOKEN };
    Type type;
    char ch;
    std::vector<std::string> seq;

    Token() : type(EOF_TOKEN), ch('\0') {}
    Token(char c) : type(CHAR), ch(c) {}
    Token(const std::vector<std::string>& s) : type(SEQUENCE), ch('\0'), seq(s) {}

    bool isChar(char c) const {
        return type == CHAR && ch == c;
    }

    bool isEOF() const {
        return type == EOF_TOKEN;
    }
};

class Rule {
public:
    enum Type { TERMINAL, IDENT, OR, REPEAT, OPTIONAL, SEQUENCE };
    Type type;
    std::string value;
    size_t idx;
    std::vector<std::unique_ptr<Rule>> rules;
    std::unique_ptr<Rule> rule;

    Rule(Type t, const std::string& v) : type(t), value(v), idx(0) {}
    Rule(Type t, const std::string& v, size_t i) : type(t), value(v), idx(i) {}
    Rule(Type t, std::vector<std::unique_ptr<Rule>> r) : type(t), idx(0), rules(std::move(r)) {}
    Rule(Type t, std::unique_ptr<Rule> r) : type(t), idx(0), rule(std::move(r)) {}

    // Copy constructor
    Rule(const Rule& other) : type(other.type), value(other.value), idx(other.idx) {
        if (other.rule) {
            rule = std::make_unique<Rule>(*other.rule);
        }
        for (const auto& r : other.rules) {
            rules.push_back(std::make_unique<Rule>(*r));
        }
    }

    // Assignment operator
    Rule& operator=(const Rule& other) {
        if (this != &other) {
            type = other.type;
            value = other.value;
            idx = other.idx;
            rule.reset();
            rules.clear();

            if (other.rule) {
                rule = std::make_unique<Rule>(*other.rule);
            }
            for (const auto& r : other.rules) {
                rules.push_back(std::make_unique<Rule>(*r));
            }
        }
        return *this;
    }

    static std::unique_ptr<Rule> createTerminal(const std::string& v) {
        return std::make_unique<Rule>(TERMINAL, v);
    }

    static std::unique_ptr<Rule> createIdent(const std::string& v, size_t i) {
        return std::make_unique<Rule>(IDENT, v, i);
    }

    static std::unique_ptr<Rule> createOr(std::vector<std::unique_ptr<Rule>> r) {
        return std::make_unique<Rule>(OR, std::move(r));
    }

    static std::unique_ptr<Rule> createRepeat(std::unique_ptr<Rule> r) {
        return std::make_unique<Rule>(REPEAT, std::move(r));
    }

    static std::unique_ptr<Rule> createOptional(std::unique_ptr<Rule> r) {
        return std::make_unique<Rule>(OPTIONAL, std::move(r));
    }

    static std::unique_ptr<Rule> createSequence(std::vector<std::unique_ptr<Rule>> r) {
        return std::make_unique<Rule>(SEQUENCE, std::move(r));
    }
};

class EBNFParser {
private:
    std::string src;
    char ch;
    size_t sdx;
    Token token;
    bool err;
    std::vector<std::string> idents;
    std::vector<std::optional<size_t>> ididx;
    std::vector<std::tuple<std::string, size_t, std::unique_ptr<Rule>>> productions;
    std::vector<std::vector<std::string>> extras;

    int btoi(bool b) {
        return b ? 1 : 0;
    }

    int invalid(const std::string& msg) {
        err = true;
        std::cout << msg << std::endl;
        sdx = src.length();
        return -1;
    }

    void skipSpaces() {
        while (sdx < src.length()) {
            ch = src[sdx];
            if (ch != ' ' && ch != '\t' && ch != '\r' && ch != '\n') {
                break;
            }
            sdx++;
        }
    }

    void getToken() {
        skipSpaces();
        if (sdx >= src.length()) {
            token = Token();
            return;
        }

        size_t tokstart = sdx;

        if (std::string("{}()[]|=.;").find(ch) != std::string::npos) {
            sdx++;
            token = Token(ch);
        } else if (ch == '"' || ch == '\'') {
            char closech = ch;
            size_t tokend = tokstart + 1;
            while (tokend < src.length() && src[tokend] != closech) {
                tokend++;
            }
            if (tokend >= src.length()) {
                invalid("no closing quote");
                token = Token();
            } else {
                sdx = tokend + 1;
                std::string content = src.substr(tokstart + 1, tokend - tokstart - 1);
                token = Token(std::vector<std::string>{"terminal", content});
            }
        } else if (std::islower(ch)) {
            while (sdx < src.length() && std::islower(src[sdx])) {
                sdx++;
            }
            std::string ident = src.substr(tokstart, sdx - tokstart);
            token = Token(std::vector<std::string>{"ident", ident});
        } else {
            invalid("invalid ebnf");
            token = Token();
        }
    }

    void matchToken(char expected_ch) {
        if (!token.isChar(expected_ch)) {
            invalid("invalid ebnf (" + std::string(1, expected_ch) + " expected)");
        } else {
            getToken();
        }
    }

    size_t addIdent(const std::string& ident) {
        auto it = std::find(idents.begin(), idents.end(), ident);
        if (it != idents.end()) {
            return std::distance(idents.begin(), it);
        } else {
            idents.push_back(ident);
            size_t k = idents.size() - 1;
            ididx.push_back(std::nullopt);
            return k;
        }
    }

    std::unique_ptr<Rule> factor() {
        if (token.type == Token::SEQUENCE) {
            if (token.seq[0] == "ident") {
                size_t idx = addIdent(token.seq[1]);
                auto rule = Rule::createIdent(token.seq[1], idx);
                getToken();
                return rule;
            } else if (token.seq[0] == "terminal") {
                auto rule = Rule::createTerminal(token.seq[1]);
                getToken();
                return rule;
            }
        } else if (token.isChar('[')) {
            getToken();
            auto expr = expression();
            matchToken(']');
            return Rule::createOptional(std::move(expr));
        } else if (token.isChar('(')) {
            getToken();
            auto expr = expression();
            matchToken(')');
            return expr;
        } else if (token.isChar('{')) {
            getToken();
            auto expr = expression();
            matchToken('}');
            return Rule::createRepeat(std::move(expr));
        }

        throw std::runtime_error("invalid token in factor() function");
    }

    std::unique_ptr<Rule> term() {
        std::vector<std::unique_ptr<Rule>> factors;
        factors.push_back(factor());

        while (!token.isEOF() && !token.isChar('|') && !token.isChar('.') &&
               !token.isChar(';') && !token.isChar(')') && !token.isChar(']') &&
               !token.isChar('}')) {
            factors.push_back(factor());
        }

        if (factors.size() == 1) {
            return std::move(factors[0]);
        } else {
            return Rule::createSequence(std::move(factors));
        }
    }

    std::unique_ptr<Rule> expression() {
        auto first_term = term();

        if (token.isChar('|')) {
            std::vector<std::unique_ptr<Rule>> terms;
            terms.push_back(std::move(first_term));
            while (token.isChar('|')) {
                getToken();
                terms.push_back(term());
            }
            return Rule::createOr(std::move(terms));
        } else {
            return first_term;
        }
    }

    Token production() {
        getToken();
        if (token.isChar('}')) {
            return token;
        }
        if (token.isEOF()) {
            invalid("invalid ebnf (missing closing })");
            return Token();
        }

        if (token.type == Token::SEQUENCE && token.seq[0] == "ident") {
            std::string ident = token.seq[1];
            size_t idx = addIdent(ident);
            getToken();
            matchToken('=');
            if (token.isEOF()) {
                return Token();
            }
            auto expr = expression();
            productions.push_back(std::make_tuple(ident, idx, std::move(expr)));
            ididx[idx] = productions.size() - 1;
            return token;
        }

        return Token();
    }

    void skipSpacesAt(const std::string& s, size_t& sdx) const {
        while (sdx < s.length()) {
            char ch = s[sdx];
            if (ch != ' ' && ch != '\t' && ch != '\r' && ch != '\n') {
                break;
            }
            sdx++;
        }
    }

    bool applies(const Rule* rule, const std::string& s, size_t& sdx) const {
        size_t was_sdx = sdx;

        switch (rule->type) {
            case Rule::SEQUENCE:
                for (const auto& r : rule->rules) {
                    if (!applies(r.get(), s, sdx)) {
                        sdx = was_sdx;
                        return false;
                    }
                }
                return true;

            case Rule::TERMINAL:
                skipSpacesAt(s, sdx);
                for (char ch : rule->value) {
                    if (sdx >= s.length() || s[sdx] != ch) {
                        sdx = was_sdx;
                        return false;
                    }
                    sdx++;
                }
                return true;

            case Rule::OR:
                for (const auto& r : rule->rules) {
                    if (applies(r.get(), s, sdx)) {
                        return true;
                    }
                }
                sdx = was_sdx;
                return false;

            case Rule::REPEAT:
                while (applies(rule->rule.get(), s, sdx)) {
                    // continue repeating
                }
                return true;

            case Rule::OPTIONAL:
                applies(rule->rule.get(), s, sdx);
                return true;

            case Rule::IDENT:
                if (ididx[rule->idx].has_value()) {
                    size_t prod_idx = ididx[rule->idx].value();
                    if (!applies(std::get<2>(productions[prod_idx]).get(), s, sdx)) {
                        sdx = was_sdx;
                        return false;
                    }
                    return true;
                } else {
                    return false;
                }
        }
        return false;
    }

    void pprintProductions() const {
        std::cout << "\nproductions:" << std::endl;
        for (const auto& prod : productions) {
            std::cout << "(" << std::get<0>(prod) << ", " << std::get<1>(prod) << ", [Rule])" << std::endl;
        }
    }

    void pprintIdents() const {
        std::cout << "\nidents:" << std::endl;
        for (const auto& ident : idents) {
            std::cout << ident << " ";
        }
        std::cout << std::endl;
    }

    void pprintIdidx() const {
        std::cout << "\nididx:" << std::endl;
        for (const auto& idx : ididx) {
            if (idx.has_value()) {
                std::cout << idx.value() << " ";
            } else {
                std::cout << "None ";
            }
        }
        std::cout << std::endl;
    }

    void pprintExtras() const {
        std::cout << "\nextras:" << std::endl;
        for (const auto& extra : extras) {
            std::cout << "[";
            for (size_t i = 0; i < extra.size(); ++i) {
                std::cout << extra[i];
                if (i < extra.size() - 1) std::cout << ", ";
            }
            std::cout << "]" << std::endl;
        }
    }

public:
    EBNFParser() : ch('\0'), sdx(0), err(false) {}

    int parse(const std::string& ebnf) {
        std::cout << "parse:\n" << ebnf << " ===>\n" << std::endl;
        err = false;
        src = ebnf;
        sdx = 0;
        idents.clear();
        ididx.clear();
        productions.clear();
        extras.clear();

        try {
            getToken();
            if (token.type == Token::SEQUENCE) {
                auto t = token.seq;
                t[0] = "title";
                extras.push_back(t);
                getToken();
            }

            if (!token.isChar('{')) {
                return invalid("invalid ebnf (missing opening {)");
            }

            while (true) {
                Token result = production();
                if (result.isChar('}') || result.isEOF()) {
                    break;
                }
            }

            getToken();
            if (token.type == Token::SEQUENCE) {
                auto t = token.seq;
                t[0] = "comment";
                extras.push_back(t);
                getToken();
            }

            if (!token.isEOF()) {
                return invalid("invalid ebnf (missing eof?)");
            }
            if (err) {
                return -1;
            }

            // Check for undefined identifiers
            for (size_t i = 0; i < ididx.size(); ++i) {
                if (!ididx[i].has_value()) {
                    return invalid("invalid ebnf (undefined:" + idents[i] + ")");
                }
            }

            pprintProductions();
            pprintIdents();
            pprintIdidx();
            pprintExtras();
            return 1;
        } catch (const std::exception& e) {
            return -1;
        }
    }

    void checkValid(const std::string& test) const {
        size_t sdx = 0;
        bool res = applies(std::get<2>(productions[0]).get(), test, sdx);
        skipSpacesAt(test, sdx);
        bool final_res = res && sdx >= test.length();
        std::string result = final_res ? "pass" : "fail";
        std::cout << "\"" << test << "\", " << result << std::endl;
    }
};

int main() {
    EBNFParser parser;

    std::vector<std::string> ebnfs = {
        R"("a" {
    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
} "z" )",
        R"({
    expr = term { plus term } .
    term = factor { times factor } .
    factor = number | '(' expr ')' .

    plus = "+" | "-" .
    times = "*" | "/" .

    number = digit { digit } .
    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
})",
        R"(a = "1")",
        R"({ a = "1" ;)",
        R"({ hello world = "1"; })",
        R"({ foo = bar . })"
    };

    std::vector<std::vector<std::string>> tests = {
        {
            "a1a3a4a4a5a6",
            "a1 a2a6",
            "a1 a3 a4 a6",
            "a1 a4 a5 a6",
            "a1 a2 a4 a5 a5 a6",
            "a1 a2 a4 a5 a6 a7",
            "your ad here"
        },
        {
            "2",
            "2*3 + 4/23 - 7",
            "(3 + 4) * 6-2+(4*(4))",
            "-2",
            "3 +",
            "(4 + 3"
        }
    };

    for (size_t i = 0; i < ebnfs.size(); ++i) {
        if (parser.parse(ebnfs[i]) == 1) {
            std::cout << "\ntests:" << std::endl;
            if (i < tests.size()) {
                for (const auto& test : tests[i]) {
                    parser.checkValid(test);
                }
            }
        }
        std::cout << std::endl;
    }

    return 0;
}
