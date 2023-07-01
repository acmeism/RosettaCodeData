#include <charconv>      // std::from_chars
#include <fstream>       // file_to_string, string_to_file
#include <functional>    // std::invoke
#include <iomanip>       // std::setw
#include <ios>           // std::left
#include <iostream>
#include <map>           // keywords
#include <sstream>
#include <string>
#include <utility>       // std::forward
#include <variant>       // TokenVal

using namespace std;

// =====================================================================================================================
// Machinery
// =====================================================================================================================
string file_to_string (const string& path)
{
    // Open file
    ifstream file {path, ios::in | ios::binary | ios::ate};
    if (!file)   throw (errno);

    // Allocate string memory
    string contents;
    contents.resize(file.tellg());

    // Read file contents into string
    file.seekg(0);
    file.read(contents.data(), contents.size());

    return contents;
}

void string_to_file (const string& path, string contents)
{
    ofstream file {path, ios::out | ios::binary};
    if (!file)    throw (errno);

    file.write(contents.data(), contents.size());
}

template <class F>
void with_IO (string source, string destination, F&& f)
{
    string input;

    if (source == "stdin")    getline(cin, input);
    else                      input = file_to_string(source);

    string output = invoke(forward<F>(f), input);

    if (destination == "stdout")    cout << output;
    else                            string_to_file(destination, output);
}

// Add escaped newlines and backslashes back in for printing
string sanitize (string s)
{
    for (auto i = 0u; i < s.size(); ++i)
    {
        if      (s[i] == '\n')    s.replace(i++, 1, "\\n");
        else if (s[i] == '\\')    s.replace(i++, 1, "\\\\");
    }

    return s;
}

class Scanner
{
public:
    const char* pos;
    int         line   = 1;
    int         column = 1;

    Scanner (const char* source) : pos {source} {}

    inline char peek ()    { return *pos; }

    void advance ()
    {
        if (*pos == '\n')    { ++line; column = 1; }
        else                 ++column;

        ++pos;
    }

    char next ()
    {
        advance();
        return peek();
    }

    void skip_whitespace ()
    {
        while (isspace(static_cast<unsigned char>(peek())))
            advance();
    }
}; // class Scanner


// =====================================================================================================================
// Tokens
// =====================================================================================================================
enum class TokenName
{
    OP_MULTIPLY, OP_DIVIDE, OP_MOD, OP_ADD, OP_SUBTRACT, OP_NEGATE,
    OP_LESS, OP_LESSEQUAL, OP_GREATER, OP_GREATEREQUAL, OP_EQUAL, OP_NOTEQUAL,
    OP_NOT, OP_ASSIGN, OP_AND, OP_OR,
    LEFTPAREN, RIGHTPAREN, LEFTBRACE, RIGHTBRACE, SEMICOLON, COMMA,
    KEYWORD_IF, KEYWORD_ELSE, KEYWORD_WHILE, KEYWORD_PRINT, KEYWORD_PUTC,
    IDENTIFIER, INTEGER, STRING,
    END_OF_INPUT, ERROR
};

using TokenVal = variant<int, string>;

struct Token
{
    TokenName name;
    TokenVal  value;
    int       line;
    int       column;
};


const char* to_cstring (TokenName name)
{
    static const char* s[] =
    {
        "Op_multiply", "Op_divide", "Op_mod", "Op_add", "Op_subtract", "Op_negate",
        "Op_less", "Op_lessequal", "Op_greater", "Op_greaterequal", "Op_equal", "Op_notequal",
        "Op_not", "Op_assign", "Op_and", "Op_or",
        "LeftParen", "RightParen", "LeftBrace", "RightBrace", "Semicolon", "Comma",
        "Keyword_if", "Keyword_else", "Keyword_while", "Keyword_print", "Keyword_putc",
        "Identifier", "Integer", "String",
        "End_of_input", "Error"
    };

    return s[static_cast<int>(name)];
}


string to_string (Token t)
{
    ostringstream out;
    out << setw(2) << t.line << "   " << setw(2) << t.column  << "   ";

    switch (t.name)
    {
        case (TokenName::IDENTIFIER)   : out << "Identifier        "   << get<string>(t.value);                  break;
        case (TokenName::INTEGER)      : out << "Integer           "   << left << get<int>(t.value);             break;
        case (TokenName::STRING)       : out << "String            \"" << sanitize(get<string>(t.value)) << '"'; break;
        case (TokenName::END_OF_INPUT) : out << "End_of_input";                                                  break;
        case (TokenName::ERROR)        : out << "Error             "   << get<string>(t.value);                  break;
        default                        : out << to_cstring(t.name);
    }

    out << '\n';

    return out.str();
}


// =====================================================================================================================
// Lexer
// =====================================================================================================================
class Lexer
{
public:
    Lexer (const char* source) : s {source}, pre_state {s} {}

    bool has_more ()    { return s.peek() != '\0'; }

    Token next_token ()
    {
        s.skip_whitespace();

        pre_state = s;

        switch (s.peek())
        {
            case '*'  :    return simply(TokenName::OP_MULTIPLY);
            case '%'  :    return simply(TokenName::OP_MOD);
            case '+'  :    return simply(TokenName::OP_ADD);
            case '-'  :    return simply(TokenName::OP_SUBTRACT);
            case '{'  :    return simply(TokenName::LEFTBRACE);
            case '}'  :    return simply(TokenName::RIGHTBRACE);
            case '('  :    return simply(TokenName::LEFTPAREN);
            case ')'  :    return simply(TokenName::RIGHTPAREN);
            case ';'  :    return simply(TokenName::SEMICOLON);
            case ','  :    return simply(TokenName::COMMA);
            case '&'  :    return expect('&', TokenName::OP_AND);
            case '|'  :    return expect('|', TokenName::OP_OR);
            case '<'  :    return follow('=', TokenName::OP_LESSEQUAL,    TokenName::OP_LESS);
            case '>'  :    return follow('=', TokenName::OP_GREATEREQUAL, TokenName::OP_GREATER);
            case '='  :    return follow('=', TokenName::OP_EQUAL,        TokenName::OP_ASSIGN);
            case '!'  :    return follow('=', TokenName::OP_NOTEQUAL,     TokenName::OP_NOT);
            case '/'  :    return divide_or_comment();
            case '\'' :    return char_lit();
            case '"'  :    return string_lit();

            default   :    if (is_id_start(s.peek()))    return identifier();
                           if (is_digit(s.peek()))       return integer_lit();
                           return error("Unrecognized character '", s.peek(), "'");

            case '\0' :    return make_token(TokenName::END_OF_INPUT);
        }
    }


private:
    Scanner s;
    Scanner pre_state;
    static const map<string, TokenName> keywords;


    template <class... Args>
    Token error (Args&&... ostream_args)
    {
        string code {pre_state.pos, (string::size_type) s.column - pre_state.column};

        ostringstream msg;
        (msg << ... << forward<Args>(ostream_args)) << '\n'
            << string(28, ' ') << "(" << s.line << ", " << s.column << "): " << code;

        if (s.peek() != '\0')    s.advance();

        return make_token(TokenName::ERROR, msg.str());
    }


    inline Token make_token (TokenName name, TokenVal value = 0)
    {
        return {name, value, pre_state.line, pre_state.column};
    }


    Token simply (TokenName name)
    {
        s.advance();
        return make_token(name);
    }


    Token expect (char expected, TokenName name)
    {
        if (s.next() == expected)    return simply(name);
        else                         return error("Unrecognized character '", s.peek(), "'");
    }


    Token follow (char expected, TokenName ifyes, TokenName ifno)
    {
        if (s.next() == expected)    return simply(ifyes);
        else                         return make_token(ifno);
    }


    Token divide_or_comment ()
    {
        if (s.next() != '*')    return make_token(TokenName::OP_DIVIDE);

        while (s.next() != '\0')
        {
            if (s.peek() == '*' && s.next() == '/')
            {
                s.advance();
                return next_token();
            }
        }

        return error("End-of-file in comment. Closing comment characters not found.");
    }


    Token char_lit ()
    {
        int n = s.next();

        if (n == '\'')    return error("Empty character constant");

        if (n == '\\')    switch (s.next())
                          {
                              case 'n'  :    n = '\n'; break;
                              case '\\' :    n = '\\'; break;
                              default   :    return error("Unknown escape sequence \\", s.peek());
                          }

        if (s.next() != '\'')    return error("Multi-character constant");

        s.advance();
        return make_token(TokenName::INTEGER, n);
    }


    Token string_lit ()
    {
        string text = "";

        while (s.next() != '"')
            switch (s.peek())
            {
                case '\\' :    switch (s.next())
                               {
                                   case 'n'  :    text += '\n'; continue;
                                   case '\\' :    text += '\\'; continue;
                                   default   :    return error("Unknown escape sequence \\", s.peek());
                               }

                case '\n' :    return error("End-of-line while scanning string literal."
                                            " Closing string character not found before end-of-line.");

                case '\0' :    return error("End-of-file while scanning string literal."
                                            " Closing string character not found.");

                default   :    text += s.peek();
            }

        s.advance();
        return make_token(TokenName::STRING, text);
    }


    static inline bool is_id_start (char c)    { return isalpha(static_cast<unsigned char>(c)) || c == '_'; }
    static inline bool is_id_end   (char c)    { return isalnum(static_cast<unsigned char>(c)) || c == '_'; }
    static inline bool is_digit    (char c)    { return isdigit(static_cast<unsigned char>(c));             }


    Token identifier ()
    {
        string text (1, s.peek());

        while (is_id_end(s.next()))    text += s.peek();

        auto i = keywords.find(text);
        if (i != keywords.end())    return make_token(i->second);

        return make_token(TokenName::IDENTIFIER, text);
    }


    Token integer_lit ()
    {
        while (is_digit(s.next()));

        if (is_id_start(s.peek()))
            return error("Invalid number. Starts like a number, but ends in non-numeric characters.");

        int n;

        auto r = from_chars(pre_state.pos, s.pos, n);
        if (r.ec == errc::result_out_of_range)    return error("Number exceeds maximum value");

        return make_token(TokenName::INTEGER, n);
    }
}; // class Lexer


const map<string, TokenName> Lexer::keywords =
{
    {"else",  TokenName::KEYWORD_ELSE},
    {"if",    TokenName::KEYWORD_IF},
    {"print", TokenName::KEYWORD_PRINT},
    {"putc",  TokenName::KEYWORD_PUTC},
    {"while", TokenName::KEYWORD_WHILE}
};


int main (int argc, char* argv[])
{
    string in  = (argc > 1) ? argv[1] : "stdin";
    string out = (argc > 2) ? argv[2] : "stdout";

    with_IO(in, out, [](string input)
    {
        Lexer lexer {input.data()};

        string s = "Location  Token name        Value\n"
                   "--------------------------------------\n";

        while (lexer.has_more())    s += to_string(lexer.next_token());
        return s;
    });
}
