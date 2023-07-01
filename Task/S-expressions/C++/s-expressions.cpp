#include <cctype>
#include <iomanip>
#include <iostream>
#include <list>
#include <memory>
#include <sstream>
#include <string>
#include <variant>

namespace s_expr {

enum class token_type { none, left_paren, right_paren, symbol, string, number };
enum class char_type { left_paren, right_paren, quote, escape, space, other };
enum class parse_state { init, quote, symbol };

struct token {
    token_type type = token_type::none;
    std::variant<std::string, double> data;
};

char_type get_char_type(char ch) {
    switch (ch) {
    case '(':
        return char_type::left_paren;
    case ')':
        return char_type::right_paren;
    case '"':
        return char_type::quote;
    case '\\':
        return char_type::escape;
    }
    if (isspace(static_cast<unsigned char>(ch)))
        return char_type::space;
    return char_type::other;
}

bool parse_number(const std::string& str, token& tok) {
    try {
        size_t pos = 0;
        double num = std::stod(str, &pos);
        if (pos == str.size()) {
            tok.type = token_type::number;
            tok.data = num;
            return true;
        }
    } catch (const std::exception&) {
    }
    return false;
}

bool get_token(std::istream& in, token& tok) {
    char ch;
    parse_state state = parse_state::init;
    bool escape = false;
    std::string str;
    token_type type = token_type::none;
    while (in.get(ch)) {
        char_type ctype = get_char_type(ch);
        if (escape) {
            ctype = char_type::other;
            escape = false;
        } else if (ctype == char_type::escape) {
            escape = true;
            continue;
        }
        if (state == parse_state::quote) {
            if (ctype == char_type::quote) {
                type = token_type::string;
                break;
            }
            else
                str += ch;
        } else if (state == parse_state::symbol) {
            if (ctype == char_type::space)
                break;
            if (ctype != char_type::other) {
                in.putback(ch);
                break;
            }
            str += ch;
        } else if (ctype == char_type::quote) {
            state = parse_state::quote;
        } else if (ctype == char_type::other) {
            state = parse_state::symbol;
            type = token_type::symbol;
            str = ch;
        } else if (ctype == char_type::left_paren) {
            type = token_type::left_paren;
            break;
        } else if (ctype == char_type::right_paren) {
            type = token_type::right_paren;
            break;
        }
    }
    if (type == token_type::none) {
        if (state == parse_state::quote)
            throw std::runtime_error("syntax error: missing quote");
        return false;
    }
    tok.type = type;
    if (type == token_type::string)
        tok.data = str;
    else if (type == token_type::symbol) {
        if (!parse_number(str, tok))
            tok.data = str;
    }
    return true;
}

void indent(std::ostream& out, int level) {
    for (int i = 0; i < level; ++i)
        out << "   ";
}

class object {
public:
    virtual ~object() {}
    virtual void write(std::ostream&) const = 0;
    virtual void write_indented(std::ostream& out, int level) const {
        indent(out, level);
        write(out);
    }
};

class string : public object {
public:
    explicit string(const std::string& str) : string_(str) {}
    void write(std::ostream& out) const { out << std::quoted(string_); }
private:
    std::string string_;
};

class symbol : public object {
public:
    explicit symbol(const std::string& str) : string_(str) {}
    void write(std::ostream& out) const {
        for (char ch : string_) {
            if (get_char_type(ch) != char_type::other)
                out << '\\';
            out << ch;
        }
    }
private:
    std::string string_;
};

class number : public object {
public:
    explicit number(double num) : number_(num) {}
    void write(std::ostream& out) const { out << number_; }
private:
    double number_;
};

class list : public object {
public:
    void write(std::ostream& out) const;
    void write_indented(std::ostream&, int) const;
    void append(const std::shared_ptr<object>& ptr) {
        list_.push_back(ptr);
    }
private:
    std::list<std::shared_ptr<object>> list_;
};

void list::write(std::ostream& out) const {
    out << "(";
    if (!list_.empty()) {
        auto i = list_.begin();
        (*i)->write(out);
        while (++i != list_.end()) {
            out << ' ';
            (*i)->write(out);
        }
    }
    out << ")";
}

void list::write_indented(std::ostream& out, int level) const {
    indent(out, level);
    out << "(\n";
    if (!list_.empty()) {
        for (auto i = list_.begin(); i != list_.end(); ++i) {
            (*i)->write_indented(out, level + 1);
            out << '\n';
        }
    }
    indent(out, level);
    out << ")";
}

class tokenizer {
public:
    tokenizer(std::istream& in) : in_(in) {}
    bool next() {
        if (putback_) {
            putback_ = false;
            return true;
        }
        return get_token(in_, current_);
    }
    const token& current() const {
        return current_;
    }
    void putback() {
        putback_ = true;
    }
private:
    std::istream& in_;
    bool putback_ = false;
    token current_;
};

std::shared_ptr<object> parse(tokenizer&);

std::shared_ptr<list> parse_list(tokenizer& tok) {
    std::shared_ptr<list> lst = std::make_shared<list>();
    while (tok.next()) {
        if (tok.current().type == token_type::right_paren)
            return lst;
        else
            tok.putback();
        lst->append(parse(tok));
    }
    throw std::runtime_error("syntax error: unclosed list");
}

std::shared_ptr<object> parse(tokenizer& tokenizer) {
    if (!tokenizer.next())
        return nullptr;
    const token& tok = tokenizer.current();
    switch (tok.type) {
    case token_type::string:
        return std::make_shared<string>(std::get<std::string>(tok.data));
    case token_type::symbol:
        return std::make_shared<symbol>(std::get<std::string>(tok.data));
    case token_type::number:
        return std::make_shared<number>(std::get<double>(tok.data));
    case token_type::left_paren:
        return parse_list(tokenizer);
    default:
        break;
    }
    throw std::runtime_error("syntax error: unexpected token");
}

} // namespace s_expr

void parse_string(const std::string& str) {
    std::istringstream in(str);
    s_expr::tokenizer tokenizer(in);
    auto exp = s_expr::parse(tokenizer);
    if (exp != nullptr) {
        exp->write_indented(std::cout, 0);
        std::cout << '\n';
    }
}

int main(int argc, char** argv) {
    std::string test_string =
        "((data \"quoted data\" 123 4.5)\n"
        " (data (!@# (4.5) \"(more\" \"data)\")))";
    if (argc == 2)
        test_string = argv[1];
    try {
        parse_string(test_string);
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << '\n';
    }
    return 0;
}
