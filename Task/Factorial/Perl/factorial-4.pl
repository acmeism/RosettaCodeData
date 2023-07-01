use ntheory qw/factorial/;
# factorial returns a UV (native unsigned int) or Math::BigInt depending on size
say length(  factorial(10000)  );
