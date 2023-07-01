BEGIN

# This version needs partial parameterisation in order to work #
# The commented code is JavaScript aka ECMAScript ES6 #


MODE F = PROC( INT ) INT ;
MODE X = PROC( X ) F ;


# Y_combinator = func_gen => ( x => x( x ) )( x => func_gen( arg => x( x )( arg ) ) ) ; #

PROC y combinator = ( PROC( F ) F func gen ) F:
  ( ( X x ) F:  x( x ) )
    (
      (
        ( PROC( F ) F func gen , X x ) F:
          func gen( ( ( X x , INT arg ) INT: x( x )( arg ) )( x , ) )
      ) ( func gen , )
    )
;


#
  factorial =
    Y_combinator( fac => ( n => ( ( n === 0 ) ? 1 : n * fac( n - 1 ) ) ) )
  ;
#

F factorial =
  y combinator(
    ( F fac ) F:
      ( ( F fac , INT n ) INT: IF n = 0 THEN 1 ELSE n * fac( n - 1 ) FI )
        ( fac , )
              )
;


#
  fibonacci =
    Y_combinator(
      fib => ( n => ( ( n === 0 ) ? 0 : ( n === 1 ) ? 1 : fib( n - 2 ) + fib( n - 1 ) ) )
                )
  ;
#

F fibonacci =
  y combinator(
    ( F fib ) F:
      ( ( F fib , INT n ) INT: CASE n IN 1 , 1 OUT fib( n - 2 ) + fib( n - 1 ) ESAC )
        ( fib , )
              )
;


# for ( i = 1 ; i <= 12 ; i++) { console.log( " " + factorial( i ) ) ; } #

INT nofacs = 12 ;
print( ( "The first " , whole( nofacs , 0 ) , " factorials." , newline ) ) ;
FOR i TO nofacs
DO
  print( whole( factorial( i ) , -11 ) )
OD ;

print( ( newline , newline ) ) ;

# for ( i = 1 ; i <= 12 ; i++) { console.log( " " + fibonacci( i ) ) ; } #

INT nofibs = 12 ;
print( ( "The first " , whole( nofibs , 0 ) , " fibonacci numbers." , newline ) ) ;
FOR i TO nofibs
DO
  print( whole( fibonacci( i ) , -11 ) )
OD ;
print( newline )

END
