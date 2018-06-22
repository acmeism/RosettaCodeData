USING: io sequences splitting ;
IN: rosetta-code.strip-chars

: strip-chars ( str str -- str ) split concat ;

"She was a soul stripper. She took my heart!" "aei" strip-chars print
