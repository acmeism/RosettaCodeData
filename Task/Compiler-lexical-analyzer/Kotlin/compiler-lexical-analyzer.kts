// Input: command line argument of file to process or console input. A two or
// three character console input of digits followed by a new line will be
// checked for an integer between zero and twenty-five to select a fixed test
// case to run. Any other console input will be parsed.

// Code based on the Java version found here:
// https://rosettacode.org/mw/index.php?title=Compiler/lexical_analyzer&action=edit&section=22

// Class to halt the parsing with an exception.
class ParsingFailed(message: String): Exception(message)

// Enumerate class of tokens supported by this scanner.
enum class TokenType {
    Tk_End_of_input, Op_multiply,  Op_divide, Op_mod, Op_add, Op_subtract,
    Op_negate, Op_not, Op_less, Op_lessequal, Op_greater, Op_greaterequal,
    Op_equal, Op_notequal, Op_assign, Op_and, Op_or, Kw_if,
    Kw_else, Kw_while, Kw_print, Kw_putc, Sy_LeftParen, Sy_RightParen,
    Sy_LeftBrace, Sy_RightBrace, Sy_Semicolon, Sy_Comma, Tk_Identifier,
    Tk_Integer, Tk_String;

    override fun toString() =
        listOf("End_of_input", "Op_multiply", "Op_divide", "Op_mod", "Op_add",
            "Op_subtract", "Op_negate", "Op_not", "Op_less", "Op_lessequal",
            "Op_greater", "Op_greaterequal", "Op_equal", "Op_notequal",
            "Op_assign", "Op_and", "Op_or", "Keyword_if", "Keyword_else",
            "Keyword_while", "Keyword_print", "Keyword_putc", "LeftParen",
            "RightParen", "LeftBrace", "RightBrace", "Semicolon", "Comma",
            "Identifier", "Integer", "String")[this.ordinal]
} // TokenType

// Data class of tokens returned by the scanner.
data class Token(val token: TokenType, val value: String, val line: Int,
        val pos: Int) {

    // Overridden method to display the token.
    override fun toString() =
        "%5d  %5d %-15s %s".format(line, pos, this.token,
            when (this.token) {
                TokenType.Tk_Integer, TokenType.Tk_Identifier ->
                    " %s".format(this.value)
                TokenType.Tk_String ->
                    this.value.toList().joinToString("", " \"", "\"") {
                        when (it) {
                            '\t' ->
                                "\\t"
                            '\n' ->
                                "\\n"
                            '\u000b' ->
                                "\\v"
                            '\u000c' ->
                                "\\f"
                            '\r' ->
                                "\\r"
                            '"' ->
                                "\\\""
                            '\\' ->
                                "\\"
                            in ' '..'~' ->
                                "$it"
                            else ->
                                "\\u%04x".format(it.code) } }
                else ->
                    "" } )
} // Token

// Function to display an error message and halt the scanner.
fun error(line: Int, pos: Int, msg: String): Nothing =
    throw ParsingFailed("(%d, %d) %s\n".format(line, pos, msg))

// Class to process the source into tokens with properties of the
// source string, the line number, the column position, the index
// within the source string, the current character being processed,
// and map of the keyword strings to the corresponding token type.
class Lexer(private val s: String) {
    private var line = 1
    private var pos = 1
    private var position = 0
    private var chr =
        if (s.isEmpty())
            ' '
        else
            s[0]
    private val keywords = mapOf<String, TokenType>(
        "if" to TokenType.Kw_if,
        "else" to TokenType.Kw_else,
        "print" to TokenType.Kw_print,
        "putc" to TokenType.Kw_putc,
        "while" to TokenType.Kw_while)

    // Method to retrive the next character from the source. Use null after
    // the end of our source.
    private fun getNextChar() =
        if (++this.position >= this.s.length) {
            this.pos++
            this.chr = '\u0000'
            this.chr
        } else {
            this.pos++
            this.chr = this.s[this.position]
            when (this.chr) {
                '\n' -> {
                    this.line++
                    this.pos = 0
                } // line
                '\t' ->
                    while (this.pos%8 != 1)
                        this.pos++
            } // when
            this.chr
        } // if

    // Method to return the division token, skip the comment, or handle the
    // error.
    private fun div_or_comment(line: Int, pos: Int): Token =
        if (getNextChar() != '*')
            Token(TokenType.Op_divide, "", line, pos);
        else {
            getNextChar() // Skip comment start
            outer@
            while (true)
                when (this.chr) {
                    '\u0000' ->
                        error(line, pos, "Lexer: EOF in comment");
                    '*' ->
                        if (getNextChar() == '/') {
                            getNextChar() // Skip comment end
                            break@outer
                        } // if
                    else ->
                        getNextChar()
                } // when
            getToken()
        } // if

    // Method to verify a character literal. Return the token or handle the
    // error.
    private fun char_lit(line: Int, pos: Int): Token {
        var c = getNextChar() // skip opening quote
        when (c) {
            '\'' ->
                error(line, pos, "Lexer: Empty character constant");
            '\\' ->
                c = when (getNextChar()) {
                    'n' ->
                        10.toChar()
                    '\\' ->
                        '\\'
                    '\'' ->
                        '\''
                    else ->
                        error(line, pos, "Lexer: Unknown escape sequence '\\%c'".
                            format(this.chr)) }
        } // when
        if (getNextChar() != '\'')
            error(line, pos, "Lexer: Multi-character constant")
        getNextChar() // Skip closing quote
        return Token(TokenType.Tk_Integer, c.code.toString(), line, pos)
    } // char_lit

    // Method to check next character to see whether it belongs to the token
    // we might be in the middle of. Return the correct token or handle the
    // error.
    private fun follow(expect: Char, ifyes: TokenType, ifno: TokenType,
            line: Int, pos: Int): Token =
        when {
            getNextChar() == expect -> {
                getNextChar()
                Token(ifyes, "", line, pos)
            } // matches
            ifno == TokenType.Tk_End_of_input ->
                error(line, pos,
                    "Lexer: %c expected: (%d) '%c'".format(expect,
                    this.chr.code, this.chr))
            else ->
                Token(ifno, "", line, pos)
        } // when

    // Method to verify a character string. Return the token or handle the
    // error.
    private fun string_lit(start: Char, line: Int, pos: Int): Token {
        var result = ""
        while (getNextChar() != start)
            when (this.chr) {
                '\u0000' ->
                    error(line, pos, "Lexer: EOF while scanning string literal")
                '\n' ->
                    error(line, pos, "Lexer: EOL while scanning string literal")
                '\\' ->
                    when (getNextChar()) {
                        '\\' ->
                            result += '\\'
                        'n' ->
                            result += '\n'
                        '"' ->
                            result += '"'
                        else ->
                            error(line, pos, "Lexer: Escape sequence unknown '\\%c'".
                                format(this.chr))
                    } // when
                else ->
                    result += this.chr
            } // when
        getNextChar() // Toss closing quote
        return Token(TokenType.Tk_String, result, line, pos)
    } // string_lit

    // Method to retrive an identifier or integer. Return the keyword
    // token, if the string matches one. Return the integer token,
    // if the string is all digits. Return the identifer token, if the
    // string is valid. Otherwise, handle the error.
    private fun identifier_or_integer(line: Int, pos: Int): Token {
        var is_number = true
        var text = ""
        while (this.chr in listOf('_')+('0'..'9')+('a'..'z')+('A'..'Z')) {
            text += this.chr
            is_number = is_number && this.chr in '0'..'9'
            getNextChar()
        } // while
        if (text.isEmpty())
            error(line, pos, "Lexer: Unrecognized character: (%d) %c".
                format(this.chr.code, this.chr))
        return when {
            text[0] in '0'..'9' ->
                if (!is_number)
                    error(line, pos, "Lexer: Invalid number: %s".
                        format(text))
                else {
                    val max = Int.MAX_VALUE.toString()
                    if (text.length > max.length || (text.length == max.length &&
                            max < text))
                        error(line, pos,
                            "Lexer: Number exceeds maximum value %s".
                            format(text))
                    Token(TokenType.Tk_Integer, text, line, pos)
                } // if
            this.keywords.containsKey(text) ->
                Token(this.keywords[text]!!, "", line, pos)
            else ->
                Token(TokenType.Tk_Identifier, text, line, pos) }
    } // identifier_or_integer

    // Method to skip whitespace both C's and Unicode ones and retrive the next
    // token.
    private fun getToken(): Token {
        while (this.chr in listOf('\t', '\n', '\u000b', '\u000c', '\r', ' ') ||
                this.chr.isWhitespace())
            getNextChar()
        val line = this.line
        val pos = this.pos
        return when (this.chr) {
            '\u0000' ->
                Token(TokenType.Tk_End_of_input, "", line, pos)
            '/' ->
                div_or_comment(line, pos)
            '\'' ->
                char_lit(line, pos)
            '<' ->
                follow('=', TokenType.Op_lessequal, TokenType.Op_less, line, pos)
            '>' ->
                follow('=', TokenType.Op_greaterequal, TokenType.Op_greater, line, pos)
            '=' ->
                follow('=', TokenType.Op_equal, TokenType.Op_assign, line, pos)
            '!' ->
                follow('=', TokenType.Op_notequal, TokenType.Op_not, line, pos)
            '&' ->
                follow('&', TokenType.Op_and, TokenType.Tk_End_of_input, line, pos)
            '|' ->
                follow('|', TokenType.Op_or, TokenType.Tk_End_of_input, line, pos)
            '"' ->
                string_lit(this.chr, line, pos)
            '{' -> {
                getNextChar()
                Token(TokenType.Sy_LeftBrace, "", line, pos)
            } // open brace
            '}' -> {
                getNextChar()
                Token(TokenType.Sy_RightBrace, "", line, pos)
            } // close brace
            '(' -> {
                getNextChar()
                Token(TokenType.Sy_LeftParen, "", line, pos)
            } // open paren
            ')' -> {
                getNextChar()
                Token(TokenType.Sy_RightParen, "", line, pos)
            } // close paren
            '+' -> {
                getNextChar()
                Token(TokenType.Op_add, "", line, pos)
            } // plus
            '-' -> {
                getNextChar()
                Token(TokenType.Op_subtract, "", line, pos)
            } // dash
            '*' -> {
                getNextChar()
                Token(TokenType.Op_multiply, "", line, pos)
            } // asterisk
            '%' -> {
                getNextChar()
                Token(TokenType.Op_mod, "", line, pos)
            } // percent
            ';' -> {
                getNextChar()
                Token(TokenType.Sy_Semicolon, "", line, pos)
            } // semicolon
            ',' -> {
                getNextChar()
                Token(TokenType.Sy_Comma, "", line, pos)
            } // comma
            else ->
                identifier_or_integer(line, pos) }
    } // getToken

    // Method to parse and display tokens.
    fun printTokens() {
        do {
            val t: Token = getToken()
            println(t)
        } while (t.token != TokenType.Tk_End_of_input)
    } // printTokens
} // Lexer


// Function to test all good tests from the website and produce all of the
// error messages this program supports.
fun tests(number: Int) {

    // Function to generate test case 0 source: Hello World/Text.
    fun hello() {
        Lexer(
"""/*
Hello world
*/
print("Hello, World!\n");
""").printTokens()
    } // hello

    // Function to generate test case 1 source: Phoenix Number.
    fun phoenix() {
        Lexer(
"""/*
Show Ident and Integers
*/
phoenix_number = 142857;
print(phoenix_number, "\n");""").printTokens()
    } // phoenix

    // Function to generate test case 2 source: All Symbols.
    fun symbols() {
        Lexer(
"""/*
  All lexical tokens - not syntactically correct, but that will
  have to wait until syntax analysis
 */
/* Print   */  print    /* Sub     */  -
/* Putc    */  putc     /* Lss     */  <
/* If      */  if       /* Gtr     */  >
/* Else    */  else     /* Leq     */  <=
/* While   */  while    /* Geq     */  >=
/* Lbrace  */  {        /* Eq      */  ==
/* Rbrace  */  }        /* Neq     */  !=
/* Lparen  */  (        /* And     */  &&
/* Rparen  */  )        /* Or      */  ||
/* Uminus  */  -        /* Semi    */  ;
/* Not     */  !        /* Comma   */  ,
/* Mul     */  *        /* Assign  */  =
/* Div     */  /        /* Integer */  42
/* Mod     */  %        /* String  */  "String literal"
/* Add     */  +        /* Ident   */  variable_name
/* character literal */  '\n'
/* character literal */  '\\'
/* character literal */  ' '""").printTokens()
    } // symbols

    // Function to generate test case 3 source: Test Case 4.
    fun four() {
        Lexer(
"""/*** test printing, embedded \n and comments with lots of '*' ***/
print(42);
print("\nHello World\nGood Bye\nok\n");
print("Print a slash n - \\n.\n");""").printTokens()
    } // four

    // Function to generate test case 4 source: Count.
    fun count() {
        Lexer(
"""count = 1;
while (count < 10) {
    print("count is: ", count, "\n");
    count = count + 1;
}""").printTokens()
    } // count

    // Function to generate test case 5 source: 100 Doors.
    fun doors() {
        Lexer(
"""/* 100 Doors */
i = 1;
while (i * i <= 100) {
    print("door ", i * i, " is open\n");
    i = i + 1;
}""").printTokens()
    } // doors

    // Function to generate test case 6 source: Negative Tests.
    fun negative() {
        Lexer(
"""a = (-1 * ((-1 * (5 * 15)) / 10));
print(a, "\n");
b = -a;
print(b, "\n");
print(-b, "\n");
print(-(1), "\n");""").printTokens()
    } // negative

    // Function to generate test case 7 source: Deep.
    fun deep() {
        Lexer(
"""print(---------------------------------+++5, "\n");
print(((((((((3 + 2) * ((((((2))))))))))))), "\n");
 
if (1) { if (1) { if (1) { if (1) { if (1) { print(15, "\n"); } } } } }""").printTokens()
    } // deep

    // Function to generate test case 8 source: Greatest Common Divisor.
    fun gcd() {
        Lexer(
"""/* Compute the gcd of 1071, 1029: 21 */
 
a = 1071;
b = 1029;
 
while (b != 0) {
    new_a = b;
    b = a % b;
    a = new_a;
}
print(a);""").printTokens()
    } // gcd

    // Function to generate test case 9 source: Factorial.
    fun factorial() {
        Lexer(
"""/* 12 factorial is 479001600 */
 
n = 12;
result = 1;
i = 1;
while (i <= n) {
    result = result * i;
    i = i + 1;
}
print(result);""").printTokens()
    } // factorial

    // Function to generate test case 10 source: Fibonacci Sequence.
    fun fibonacci() {
        Lexer(
"""/* fibonacci of 44 is 701408733 */
 
n = 44;
i = 1;
a = 0;
b = 1;
while (i < n) {
    w = a + b;
    a = b;
    b = w;
    i = i + 1;
}
print(w, "\n");""").printTokens()
    } // fibonacci

    // Function to generate test case 11 source: FizzBuzz.
    fun fizzbuzz() {
        Lexer(
"""/* FizzBuzz */
i = 1;
while (i <= 100) {
    if (!(i % 15))
        print("FizzBuzz");
    else if (!(i % 3))
        print("Fizz");
    else if (!(i % 5))
        print("Buzz");
    else
        print(i);
 
    print("\n");
    i = i + 1;
}""").printTokens()
    } // fizzbuzz

    // Function to generate test case 12 source: 99 Bottles of Beer.
    fun bottles() {
        Lexer(
"""/* 99 bottles */
bottles = 99;
while (bottles > 0) {
    print(bottles, " bottles of beer on the wall\n");
    print(bottles, " bottles of beer\n");
    print("Take one down, pass it around\n");
    bottles = bottles - 1;
    print(bottles, " bottles of beer on the wall\n\n");
}""").printTokens()
    } // bottles

    // Function to generate test case 13 source: Primes.
    fun primes() {
        Lexer(
"""/*
Simple prime number generator
*/
count = 1;
n = 1;
limit = 100;
while (n < limit) {
    k=3;
    p=1;
    n=n+2;
    while ((k*k<=n) && (p)) {
        p=n/k*k!=n;
        k=k+2;
    }
    if (p) {
        print(n, " is prime\n");
        count = count + 1;
    }
}
print("Total primes found: ", count, "\n");""").printTokens()
    } // primes

    // Function to generate test case 14 source: Ascii Mandelbrot.
    fun ascii() {
        Lexer(
"""{
/*
 This is an integer ascii Mandelbrot generator
 */
    left_edge   = -420;
    right_edge  =  300;
    top_edge    =  300;
    bottom_edge = -300;
    x_step      =    7;
    y_step      =   15;

    max_iter    =  200;

    y0 = top_edge;
    while (y0 > bottom_edge) {
        x0 = left_edge;
        while (x0 < right_edge) {
            y = 0;
            x = 0;
            the_char = ' ';
            i = 0;
            while (i < max_iter) {
                x_x = (x * x) / 200;
                y_y = (y * y) / 200;
                if (x_x + y_y > 800 ) {
                    the_char = '0' + i;
                    if (i > 9) {
                        the_char = '@';
                    }
                    i = max_iter;
                }
                y = x * y / 100 + y0;
                x = x_x - y_y + x0;
                i = i + 1;
            }
            putc(the_char);
            x0 = x0 + x_step;
        }
        putc('\n');
        y0 = y0 - y_step;
    }
}
""").printTokens()
    } // ascii

    when (number) {
        0 ->
            hello()
        1 ->
            phoenix()
        2 ->
            symbols()
        3 ->
            four()
        4 ->
            count()
        5 ->
            doors()
        6 ->
            negative()
        7 ->
            deep()
        8 ->
            gcd()
        9 ->
            factorial()
        10 ->
            fibonacci()
        11 ->
            fizzbuzz()
        12 ->
            bottles()
        13 ->
            primes()
        14 ->
            ascii()
        15 -> // Lexer: Empty character constant
            Lexer("''").printTokens()
        16 -> // Lexer: Unknown escape sequence
            Lexer("'\\x").printTokens()
        17 -> // Lexer: Multi-character constant
            Lexer("'  ").printTokens()
        18 -> // Lexer: EOF in comment
            Lexer("/*").printTokens()
        19 -> // Lexer: EOL in string
            Lexer("\"\n").printTokens()
        20 -> // Lexer: EOF in string
            Lexer("\"").printTokens()
        21 -> // Lexer: Escape sequence unknown
            Lexer("\"\\x").printTokens()
        22 -> // Lexer: Unrecognized character
            Lexer("~").printTokens()
        23 -> // Lexer: invalid number
            Lexer("9a9").printTokens()
        24 -> // Lexer: Number exceeds maximum value
            Lexer("2147483648\n9223372036854775808").printTokens()
        25 -> // Lexer: Operator expected
            Lexer("|.").printTokens()
        else ->
            println("Invalid test number %d!".format(number))
    } // when
} // tests

// Main function to check our source and read its data before parsing it.
// With no source specified, run the test of all symbols.
fun main(args: Array<String>) {
    try {
        val s =
            if (args.size > 0 && args[0].isNotEmpty()) // file on command line
                java.util.Scanner(java.io.File(args[0]))
            else  // use the console
                java.util.Scanner(System.`in`)
        var source = ""
        while (s.hasNext())
            source += s.nextLine()+
                if (s.hasNext())
                    "\n"
                else
                    ""
        if (args.size > 0 && args[0].isNotEmpty()) // file on command line
            Lexer(source).printTokens()
        else {
            val digits = source.filter { it in '0'..'9' }
            when {
                source.isEmpty() -> // nothing given
                    tests(2)
                source.length in 1..2 && digits.length == source.length &&
                        digits.toInt() in 0..25 ->
                    tests(digits.toInt())
                else ->
                    Lexer(source).printTokens()
            } // when
        } // if
    } catch(e: Throwable) {
        println(e.message)
        System.exit(1)
    } // try
} // main
