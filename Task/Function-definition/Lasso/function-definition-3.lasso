// Signatures that convert second input to match first input
define multiply(a::integer,b::any) => #a * integer(#b)
define multiply(a::decimal,b::any) => #a * decimal(#b)

// Catch all signature
define multiply(a::any,b::any) => decimal(#a) * decimal(#b)
