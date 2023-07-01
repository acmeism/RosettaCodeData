USING: io math prettyprint see ;

"The list of methods contained in the generic word + :" print
\ + methods . nl

"The list of methods specializing on the fixnum class:" print
fixnum methods .
