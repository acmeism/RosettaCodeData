#include <ciso646>
#include <iostream>
#include <regex>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

using std::vector;
using std::string;

//-------------------------------------------------------------------------------------------------
// throw error( "You ", profanity, "ed up!" );  // Don't mess up, okay?
//-------------------------------------------------------------------------------------------------
#include <exception>
#include <stdexcept>
template <typename...Args> std::runtime_error error( Args...args )
{
  return std::runtime_error( (std::ostringstream{} << ... << args).str() );
};

//-------------------------------------------------------------------------------------------------
// Stack
//-------------------------------------------------------------------------------------------------
// Let us co-opt a vector for our stack type.
// C++ pedants: no splicing possible == totally okay to do this.
//
// Note: C++ provides a more appropriate std::stack class, except that the task requires us to
// be able to display its contents, and that kind of access is an expressly non-stack behavior.

template <typename T> struct stack : public std::vector <T>
{
  using base_type = std::vector <T> ;
  T        push ( const T& x ) { base_type::push_back( x ); return x; }
  const T& top  ()             { return base_type::back(); }
  T        pop  ()             { T x = std::move( top() ); base_type::pop_back(); return x; }
  bool     empty()             { return base_type::empty(); }
};

//-------------------------------------------------------------------------------------------------
using Number = double;
//-------------------------------------------------------------------------------------------------
// Numbers are already too awesome to need extra diddling.

//-------------------------------------------------------------------------------------------------
// Operators
//-------------------------------------------------------------------------------------------------
using Operator_Name = string;
using Precedence    = int;
enum class Associates { none, left_to_right, right_to_left };

struct Operator_Info { Precedence precedence; Associates associativity; };

std::unordered_map <Operator_Name, Operator_Info>  Operators =
{
  { "^", { 4, Associates::right_to_left } },
  { "*", { 3, Associates::left_to_right } },
  { "/", { 3, Associates::left_to_right } },
  { "+", { 2, Associates::left_to_right } },
  { "-", { 2, Associates::left_to_right } },
};

Precedence precedence   ( const Operator_Name& op ) { return Operators[ op ].precedence; }
Associates associativity( const Operator_Name& op ) { return Operators[ op ].associativity; }

//-------------------------------------------------------------------------------------------------
using Token = string;
//-------------------------------------------------------------------------------------------------
bool is_number           ( const Token& t ) { return regex_match( t, std::regex{ R"z((\d+(\.\d*)?|\.\d+)([Ee][\+\-]?\d+)?)z" } ); }
bool is_operator         ( const Token& t ) { return Operators.count( t ); }
bool is_open_parenthesis ( const Token& t ) { return t == "("; }
bool is_close_parenthesis( const Token& t ) { return t == ")"; }
bool is_parenthesis      ( const Token& t ) { return is_open_parenthesis( t ) or is_close_parenthesis( t ); }

//-------------------------------------------------------------------------------------------------
// std::cout << a_vector_of_something;
//-------------------------------------------------------------------------------------------------
// Weird C++ stream operator stuff (for I/O).
// Don't worry if this doesn't look like it makes any sense.
//
template <typename T> std::ostream& operator << ( std::ostream& outs, const std::vector <T> & xs )
{
  std::size_t n = 0;  for (auto x : xs) outs << (n++ ? " " : "") << x;  return outs;
}

//-------------------------------------------------------------------------------------------------
// Progressive_Display
//-------------------------------------------------------------------------------------------------
// This implements the required task:
//   "use the algorithm to show the changes in the operator
//    stack and RPN output as each individual token is processed"
//
#include <iomanip>

struct Progressive_Display
{
  string token_name;
  string token_type;

  Progressive_Display()  // Header for the table we are going to generate
  {
    std::cout << "\n"
      "  INPUT │ TYPE │ ACTION           │ STACK        │ OUTPUT\n"
      "────────┼──────┼──────────────────┼──────────────┼─────────────────────────────\n";
  }

  Progressive_Display& operator () ( const Token& token )  // Ready the first two columns
  {
    token_name = token;
    token_type = is_operator   ( token ) ? "op"
               : is_parenthesis( token ) ? "()"
               : is_number     ( token ) ? "num"
               : "";
    return *this;
  }

  Progressive_Display& operator () (  // Display all columns of a row
    const string         & description,
    const stack  <Token> & stack,
    const vector <Token> & output )
  {
    std::cout                                                              << std::right
      << std::setw(  7 ) << token_name                            << " │ " << std::left
      << std::setw(  4 ) << token_type                            << " │ "
      << std::setw( 16 ) << description                           << " │ "
      << std::setw( 12 ) << (std::ostringstream{} << stack).str() << " │ "
      <<                    output                                << "\n";
    return operator () ( "" );  // Reset the first two columns to empty for next iteration
  }
};

//-------------------------------------------------------------------------------------------------
vector <Token> parse( const vector <Token> & tokens )
//-------------------------------------------------------------------------------------------------
{
  vector <Token> output;
  stack  <Token> stack;

  Progressive_Display display;

  for (auto token : tokens)  // Shunting Yard takes a single linear pass through the tokens

    //.........................................................................
    if (is_number( token ))
    {
      output.push_back( token );
      display( token )( "num --> output", stack, output );
    }

    //.........................................................................
    else if (is_operator( token ) or is_parenthesis( token ))
    {
      display( token );

      if (!is_open_parenthesis( token ))
      {
        // pop --> output
        //   : until '(' if token is ')'
        //   : while prec(token) > prec(top)
        //   : while prec(token) == prec(top) AND assoc(token) is left-to-right
        while (!stack.empty()
          and (   (is_close_parenthesis( token ) and !is_open_parenthesis( stack.top() ))
               or (precedence( stack.top() ) > precedence( token ))
               or (    (precedence( stack.top() ) == precedence( token ))
                   and (associativity( token ) == Associates::left_to_right))))
        {
          output.push_back( stack.pop() );
          display( "pop --> output", stack, output );
        }

        // If we popped until '(' because token is ')', toss both parens
        if (is_close_parenthesis( token ))
        {
          stack.pop();
          display( "pop", stack, output );
        }
      }

      // Everything except ')' --> stack
      if (!is_close_parenthesis( token ))
      {
        stack.push( token );
        display( "push op", stack, output );
      }
    }

    //.........................................................................
    else throw error( "unexpected token: ", token );

  // Anything left on the operator stack just gets moved to the output

  display( "END" );
  while (!stack.empty())
  {
    output.push_back( stack.pop() );
    display( "pop --> output", stack, output );
  }

  return output;
}

//-------------------------------------------------------------------------------------------------
int main( int argc, char** argv )
//-------------------------------------------------------------------------------------------------
try
{
  auto tokens   = vector <Token> ( argv+1, argv+argc );
  auto rpn_expr = parse( tokens );
  std::cout
    << "\nInfix = " << tokens
    << "\nRPN   = " << rpn_expr
    << "\n";
}
catch (std::exception e)
{
  std::cerr << "error: " << e.what() << "\n";
  return 1;
}
