// A straight-forward brute-force C++ version with formatted output,
// eschewing obfuscation and C-isms, producing ALL solutions, which
// works on any OS with a text terminal.
//
// Two basic optimizations are applied:
//
//   It uses backtracking to only construct potentially valid solutions.
//
//   It only computes half the solutions by brute -- once we get the
//   queen halfway across the top row, any remaining solutions must be
//   reflections of the ones already computed.
//
// This is a bare-bones example, without any progress feedback or output
// formatting controls, which a more complete program might provide.
//
// Beware that computing anything larger than N=14 might take a while.
// (Time gets exponentially worse the higher the number.)

// Copyright 2014 Michael Thomas Greer
// Distributed under the Boost Software License, Version 1.0.
// http://www.boost.org/LICENSE_1_0.txt

#include <algorithm>
#include <ciso646>
#include <iomanip>
#include <iostream>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>


// ///////////////////////////////////////////////////////////////////////////
struct queens
/////////////////////////////////////////////////////////////////////////// //
{
  // TYPES -------------------------------------------------------------------

  // A row or column index. (May be signed or unsigned.)
  //
  typedef signed char index_type;

  // A 'solution' is a row --> column lookup of queens on the board.
  //
  // It has lexicographical order and can be transformed with a variety of
  // reflections, which, when properly combined, produce all possible
  // orientations of a solution.
  //
  struct solution_type: std::vector <index_type>
  {
    typedef std::vector <index_type> base_type;

    // constructors  . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    solution_type( std::size_t N          ): base_type( N, -1 ) { }
    solution_type( const solution_type& s ): base_type( s     ) { }

    // compare . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    bool operator < ( const solution_type& s ) const
    {
      auto mm = std::mismatch( begin(), end(), s.begin() );
      return (mm.first != end()) and (*mm.first < *mm.second);
    }

    // transformations . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    void vflip() { std::reverse( begin(), end() ); }

    void hflip() { for (auto& x : *this) x = size() - 1 - x; }

    void transpose()
    {
      solution_type result( size() );
      for (index_type y = 0; (std::size_t)y < size(); y++)
        result[ (*this)[ y ] ] = y;
      swap( result );
    }
  };

  // MEMBER VALUES -----------------------------------------------------------

  const int                N;
  std::set <solution_type> solutions;

  // SOLVER ------------------------------------------------------------------

  queens( int N = 8 ):
    N( (N < 0) ? 0 : N )
  {
    // Row by row we create a potentially valid solution.
    // If a queen can be placed in a valid spot by the time
    // we get to the last row, then we've found a solution.

    solution_type solution( N );
    index_type row = 0;
    while (true)
    {
      // Advance the queen along the row
      ++solution[ row ];

      // (If we get past halfway through the first row, we're done.)
      if ((row == 0) and (solution[ 0 ] > N/2)) break;

      if (solution[ row ] < N)
      {
        // If the queen is in a good spot...
        if (ok( solution, row, solution[ row ] ))
        {
          // ...and we're on the last row
          if (row == N-1)
          {
            // Add the solution we found plus all it's reflections
            solution_type
            s = solution;  solutions.insert( s );
            s.vflip();     solutions.insert( s );
            s.hflip();     solutions.insert( s );
            s.vflip();     solutions.insert( s );
            s.transpose(); solutions.insert( s );
            s.vflip();     solutions.insert( s );
            s.hflip();     solutions.insert( s );
            s.vflip();     solutions.insert( s );
          }
          // otherwise begin marching a queen along the next row
          else solution[ ++row ] = -1;
        }

      // When we get to the end of a row's columns then
      // we need to backup a row and continue from there.
      }
      else --row;
    }
  }

  // HELPER ------------------------------------------------------------------
  // This routine helps the solver by identifying column locations
  // that do not conflict with queens already placed in prior rows.

  bool ok( const solution_type& columns, index_type row, index_type column )
  {
    for (index_type r = 0; r < row; r++)
    {
      index_type c         = columns[ r ];
      index_type delta_row = row - r;
      index_type delta_col = (c < column) ? (column - c) : (c - column);

      if ((c == column) or (delta_row == delta_col))
        return false;
    }
    return true;
  }

  // OUTPUT A SINGLE SOLUTION ------------------------------------------------
  //
  // Formatted as (for example):
  //
  //   d1 b2 g3 c4 f5 h6 e7 a8
  //   Q - - - - - - -
  //   - - - - Q - - -
  //   - - - - - - - Q
  //   - - - - - Q - -
  //   - - Q - - - - -
  //   - - - - - - Q -
  //   - Q - - - - - -
  //   - - - Q - - - -
  //
  friend
  std::ostream&
  operator << ( std::ostream& outs, const queens::solution_type& solution )
  {
    static const char* squares[] = { "- ", "Q " };
    index_type N = solution.size();

    // Display the queen positions
    for (auto n = N; n--; )
      outs << (char)('a' + solution[ n ]) << (N - n) << " ";

    // Display the board
    for (auto queen : solution)
    {
      outs << "\n";
      for (index_type col = 0; col < N; col++)
        outs << squares[ col == queen ];
    }
    return outs;
  }

  // OUTPUT ALL SOLUTIONS ----------------------------------------------------
  //
  // Display "no solutions" or "N solutions" followed by
  // each individual solution, separated by blank lines.

  friend
  std::ostream&
  operator << ( std::ostream& outs, const queens& q )
  {
    if (q.solutions.empty()) outs << "no";
    else                     outs << q.solutions.size();
    outs << " solutions";

    std::size_t n = 1;
    for (auto solution : q.solutions)
    {
      outs << "\n\n#" << n++ << "\n" << solution;
    }

    return outs;
  }
};


/* ///////////////////////////////////////////////////////////////////////////
string_to <type> ( x )
/////////////////////////////////////////////////////////////////////////// */

template <typename T>
T string_to( const std::string& s )
{
  T result;
  std::istringstream ss( s );
  ss >> result;
  if (!ss.eof()) throw std::runtime_error( "to_string(): invalid conversion" );
  return result;
}

template <typename T, T default_value>
T string_to( const std::string& s )
{
  try { return string_to <T> ( s ); }
  catch (...) { return default_value; }
}


/* ///////////////////////////////////////////////////////////////////////////
main program
/////////////////////////////////////////////////////////////////////////// */

int usage( const std::string& name )
{
  std::cerr <<
    "usage:\n  " << name << " 8\n\n"
    ""
    "Solve the N-Queens problem, brute-force,\n"
    "and show all solutions for an 8x8 board.\n\n"
    ""
    "(Specify a value other than 8 for the board size you want.)\n";
  return 1;
}

int main( int argc, char** argv )
{
  signed N =
    (argc < 2) ? 8 :
    (argc > 2) ? 0 : string_to <signed, 0> ( argv[ 1 ] );

  if (N <= 0) return usage( argv[ 0 ] );

  std::cout << queens( N ) << "\n";
}
