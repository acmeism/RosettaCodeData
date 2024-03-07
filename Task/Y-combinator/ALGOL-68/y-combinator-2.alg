BEGIN

# This version needs partial parameterisation in order to work #
# The commented code is JavaScript aka ECMAScript ES6 #


MODE F = PROC( INT ) INT ;
MODE X = PROC( X ) F ;


#
Y_combinator =
  func_gen => ( x => x( x ) )( x => func_gen( arg => x( x )( arg ) ) )
#

PROC y combinator = ( PROC( F ) F func gen ) F:
( ( X x ) F:  x( x ) )
  (
    (
      ( PROC( F ) F func gen , X x ) F:
        func gen( ( ( X x , INT arg ) INT: x( x )( arg ) )( x , ) )
    )( func gen , )
  )
;


#
fac_gen = fac => (n => ( ( n === 0 ) ? 1 : n * fac( n - 1 ) ) )
#

PROC fac gen = ( F fac ) F:
( ( F fac , INT n ) INT: IF n = 0 THEN 1 ELSE n * fac( n - 1 ) FI )( fac , )
;


#
factorial = Y_combinator( fac_gen )
#

F factorial = y combinator( fac gen ) ;


#
fib_gen =
  fib =>
    ( n => ( ( n === 0 ) ? 0 : ( n === 1 ) ? 1 : fib( n - 2 ) + fib( n - 1 ) ) )
#

PROC fib gen = ( F fib ) F:
(
  ( F fib , INT n ) INT:
  CASE n + 1 IN 0 , 1 OUT fib( n - 2 ) + fib( n - 1 ) ESAC
)( fib , )
;


#
fibonacci = Y_combinator( fib_gen )
#

F fibonacci = y combinator( fib gen ) ;


#
for ( i = 1 ; i <= 12 ; i++) { process.stdout.write( " " + factorial( i ) ) }
#

INT nofacs = 12 ;
printf( ( $ l , "Here are the first " , g( 0 ) , " factorials." , l $ , nofacs ) ) ;
FOR i TO nofacs
DO
  printf( ( $ "  " , g( 0 ) $ , factorial( i ) ) )
OD ;
print( newline ) ;


#
for ( i = 1 ; i <= 12 ; i++) { process.stdout.write( " " + fibonacci( i ) ) }
#

INT nofibs = 12 ;
printf( (
  $ l , "Here are the first " , g( 0 ) , " fibonacci numbers." , l $
, nofibs
      ) )
;
FOR i TO nofibs
DO
  printf( ( $ "  " , g( 0 ) $ , fibonacci( i ) ) )
OD ;
print( newline )

END
