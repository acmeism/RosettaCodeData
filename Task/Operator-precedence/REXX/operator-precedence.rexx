/*
 ╔══════════════════════════════════════════════════════════════════════╗
 ║                                                                      ║
 ║ The following is a table that lists the precedence and associativity ║
 ║ of all the operators in the (classic) REXX language.                 ║
 ║                                                                      ║
 ║     1   is the highest precedence.                                   ║
 ║                                                                      ║
 ╠══════════╤════════╤══════════════════════════════════════════════════╣
 ║          │        │                                                  ║
 ║precedence│operator│               description                        ║
 ║          │        │                                                  ║
 ╟──────────┼────────┼──────────────────────────────────────────────────╢
 ║    1     │   -    │  unary minus                                     ║
 ║          │   +    │  unary plus                                      ║
 ║          │   \    │  logical not                                     ║
 ║          │        ├──(the following aren't supported by all REXXes)──╢
 ║          │   ¬    │  logical not                                     ║
 ║          │   ~    │  logical not                                     ║
 ║          │   ^    │  logical not                                     ║
 ╟──────────┼────────┼──────────────────────────────────────────────────╢
 ║    2     │   **   │  exponentiation    (integer power)               ║
 ╟──────────┼────────┼──────────────────────────────────────────────────╢
 ║    3     │   *    │  multiplication                                  ║
 ║          │   /    │  division                                        ║
 ║          │   %    │  integer division                                ║
 ║          │   //   │  modulus   (remainder division, sign of dividend)║
 ║          │  / /   │  modulus   (any 2 or 3 character operators may   ║
 ║          │        │             have whitespace between characters.) ║
 ╟──────────┼────────┼──────────────────────────────────────────────────╢
 ║    4     │   +    │  addition                                        ║
 ║          │   -    │  subtraction                                     ║
 ╟──────────┼────────┼──────────────────────────────────────────────────╢
 ║    5     │   ||   │  concatenation                                   ║
 ╟──────────┼────────┼──────────────────────────────────────────────────╢
 ║    6     │   &    │  logical AND                                     ║
 ║          │   |    │  logical OR      (inclusive OR)                  ║
 ║          │   &&   │  logical XOR     (exclusive OR)                  ║
 ╟──────────┼────────┼──────────────────────────────────────────────────╢
 ║    7     │[blank] │  concatenation                                   ║
 ║          │abuttal │  concatenation                                   ║
 ╟──────────┼────────┼──────────────────────────────────────────────────╢
 ║    8     │   =    │  equal to                                        ║
 ║          │   ==   │  exactly equal to   (also, strictly equal to)    ║
 ║          │   \=   │  not equal to                                    ║
 ║          │   <>   │  not equal to  (also, less than or greater than) ║
 ║          │   ><   │  not equal to  (also, greater than or less than) ║
 ║          │   >    │  greater than                                    ║
 ║          │   >=   │  greater than or equal to                        ║
 ║          │   <    │  less than                                       ║
 ║          │   <=   │  less than or equal to                           ║
 ║          │   >>   │  exactly greater than                            ║
 ║          │   <<   │  exactly less than                               ║
 ║          │  <<=   │  exactly less than or equal to                   ║
 ║          │  >>=   │  exactly greater than or equal to                ║
 ║          │        ├──(the following aren't supported by all REXXes)──╢
 ║          │   /=   │  not equal to                                    ║
 ║          │   ¬=   │  not equal to                                    ║
 ║          │   ~=   │  not equal to                                    ║
 ║          │   ^=   │  not equal to                                    ║
 ║          │  /==   │  not exactly equal to                            ║
 ║          │  \==   │  not exactly equal to                            ║
 ║          │  ¬==   │  not exactly equal to                            ║
 ║          │  ~==   │  not exactly equal to                            ║
 ║          │  ^==   │  not exactly equal to                            ║
 ║          │   /<   │  not less than                                   ║
 ║          │   ~<   │  not less than                                   ║
 ║          │   ¬<   │  not less than                                   ║
 ║          │   ^<   │  not less than                                   ║
 ║          │   />   │  not greater than                                ║
 ║          │   ¬>   │  not greater than                                ║
 ║          │   ~>   │  not greater than                                ║
 ║          │   ^>   │  not greater than                                ║
 ║          │  /<=   │  not less than or equal to                       ║
 ║          │  ¬<=   │  not less than or equal to                       ║
 ║          │  ~<=   │  not less than or equal to                       ║
 ║          │  ^<=   │  not less than or equal to                       ║
 ║          │  />=   │  not greater than or equal to                    ║
 ║          │  ¬>=   │  not greater than or equal to                    ║
 ║          │  ~>=   │  not greater than or equal to                    ║
 ║          │  ^>=   │  not greater than or equal to                    ║
 ║          │  \>>   │  not exactly greater than                        ║
 ║          │  ¬>>   │  not exactly greater than                        ║
 ║          │  ~>>   │  not exactly greater than                        ║
 ║          │  ^>>   │  not exactly greater than                        ║
 ║          │  \<<   │  not exactly less than                           ║
 ║          │  ¬<<   │  not exactly less than                           ║
 ║          │  ~<<   │  not exactly less than                           ║
 ║          │  ^<<   │  not exactly less than                           ║
 ╚══════════╧════════╧══════════════════════════════════════════════════╝   */
