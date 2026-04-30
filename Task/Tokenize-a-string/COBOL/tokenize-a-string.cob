      identification division.
       program-id. tokenize.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 period constant as ".".
       01 cmma   constant as ",".

       01 start-with.
          05 value "Hello,How,Are,You,Today".

       01 items.
          05 item pic x(6) occurs 5 times.

       procedure division.
       tokenize-main.
       unstring start-with delimited by cmma
           into item(1) item(2) item(3) item(4) item(5)

       display trim(item(1)) period trim(item(2)) period
               trim(item(3)) period trim(item(4)) period
               trim(item(5))

       goback.
       end program tokenize.
