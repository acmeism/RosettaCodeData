#include <iostream> // Only for cout to demonstrate

int main()
{
  std::cout <<
R"EOF(  A  raw  string  begins  with  R,  then a double-quote ("),  then an optional
identifier (here I've used "EOF"),  then an opening parenthesis ('(').  If you
use  an  identifier,  it  cannot  be longer than 16 characters,  and it cannot
contain a space,  either opening or closing parentheses, a backslash, a tab, a
vertical tab, a form feed, or a newline.

  It  ends with a closing parenthesis (')'),  the identifer (if you used one),
and a double-quote.

  All  characters are okay in a raw string,  no escape sequences are necessary
or recognized, and all whitespace is preserved.
)EOF";
}
