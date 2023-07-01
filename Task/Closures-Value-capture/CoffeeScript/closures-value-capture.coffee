# Generate an array of functions.
funcs = ( for i in [ 0...10 ] then do ( i ) -> -> i * i )

# Call each function to demonstrate value capture.
console.log func() for func in funcs
