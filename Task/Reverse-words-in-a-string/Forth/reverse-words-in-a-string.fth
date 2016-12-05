create buf 1000 chars allot                    \ string buffer
buf value pp                                   \ pp points to buffer address

: tr        ( caddr u -- )
            dup >r pp swap cmove               \ move string into buffer
            r> pp + to pp  ;                   \ advance pointer by u bytes

: collect   ( -- addr len .. addr[n] len[n])   \ words deposit on data stack
            begin
              parse-name dup                   \ parse input stream, dup the len
            while                              \ while  stack <> 0
              tuck pp >r tr r>  swap
            repeat
            2drop ;                            \ clean up stack

: reverse   ( -- )
            buf to pp                          \ initialize pointer to buffer address
            collect
            depth 2/ 0 ?do  type space  loop   \ type the strings with a trailing space
            cr ;                               \ final new line

reverse ---------- Ice and Fire ------------
reverse
reverse fire, in end will world the say Some
reverse ice. in say Some
reverse desire of tasted I've what From
reverse fire. favor who those with hold I
reverse
reverse ... elided paragraph last ...
reverse
reverse Frost Robert -----------------------
