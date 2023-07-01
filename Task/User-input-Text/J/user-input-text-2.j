   prompt 'Enter string: '                    NB. output string to session
Enter string: Hello World
Hello World
   0".prompt 'Enter an integer: '             NB. output integer to session
Enter an integer: 75000
75000
   mystring=: prompt 'Enter string: '         NB. store string as noun
Enter string: Hello Rosetta Code
   myinteger=: 0".prompt 'Enter an integer: ' NB. store integer as noun
Enter an integer: 75000
   mystring;myinteger                         NB. show contents of nouns
┌──────────────────┬─────┐
│Hello Rosetta Code│75000│
└──────────────────┴─────┘
