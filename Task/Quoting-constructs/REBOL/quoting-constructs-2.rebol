"tab is: ^-"            ;; A string literal in double quotes.
                        ;; ^- inside a string is an escape for the TAB character in Rebol.
                        ;; So this represents:  tab is: <tab>

"double-quote is: ^"""  ;; String literal containing a double quote character.
                        ;; In Rebol strings, ^" is an escape sequence for a literal quote.
                        ;; This yields:  double-quote is: "

{double-quote is: "}    ;; String literal in curly braces { }.
                        ;; Inside { }, double quotes don't need escaping.
                        ;; This simply yields:  double-quote is: "

"foo {"                 ;; String literal in double quotes that contains an opening brace {.
                        ;; In double-quoted strings, braces are just characters, no special meaning.
                        ;; Yields: foo {

{foo ^{}                ;; String literal in curly braces containing an opening brace {.
                        ;; In { }, the sequence ^{ is an escape for the brace.
                        ;; Otherwise an unescaped } would end the string.
                        ;; Yields: foo {
;; Additionally in Rebol 3:
%%{raw string don't needs escapes for " or {}%%
