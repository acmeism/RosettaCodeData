! INCLUDING macro that imports source code files in the current directory

USING: kernel vocabs.loader parser sequences lexer vocabs.parser ;
IN: syntax

: include-vocab ( vocab -- ) dup ".factor" append parse-file append use-vocab ;

SYNTAX: INCLUDING: ";" [ include-vocab ] each-token ;
