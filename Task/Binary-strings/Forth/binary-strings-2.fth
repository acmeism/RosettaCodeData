\ Rosetta Code Binary String tasks Console Tests

\ 1. String creation and destruction (when needed and if there's no garbage collection or similar mechanism)

\ RAW Forth can manually create a binary string with the C, operator.
\ C, takes a byte off the stack and writes it into the next available memory address
\ then increments the Forth internal memory pointer by 1 byte.
\ 'binary_string'  drops it's address on the stack. Nothing more. (ie: pointer to the string)

HEX ok
    create binary_string   9 c,  1 c, 2 c, 3 c, 4 c, 5 c,
                           0A c, 0B c, 0C c, 0FF c,        \ 1st byte is length
ok

\ test what we created using the DUMP utility

 binary_string count dump
 25EC:7365  01 02 03 04 05 0A 0B 0C  FF 04 44 55 4D 50 00 20  ..........DUMP.
 ok


\ Alternatively we can create static string variables using our constructor
    string: buffer1  ok
    string: buffer2  ok

DECIMAL  ok

\ 2. String assignment

\ create string constants with assignments(static, counted strings)  ok
     create string1  ," Now is the time for all good men to come to the aid"
     create string2  ," Right now!"  ok

\ assign text to string variables with syntacic sugar
     buffer1 =" This text will go into the memory allocated for buffer1"  ok
     buffer2 =""  ok

\ or use S" and PLACE
     S" The rain in Spain..." buffer2 PLACE ok

\ Test the assignments
     string2 writestr Right now!
 ok
     string1 writestr Now is the time for all good men to come to the aid
 ok
     buffer1 writestr This text will go into the memory allocated for buffer1
 ok
     buffer2 writestr The rain in Spain...
 ok


\ destroy string contents. Fill string with zero
     buffer1 clearstr  ok
     buffer1 40 dump
25EC:7370  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  ................
25EC:7380  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  ................
25EC:7390  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  ................
 ok

\ 3. String comparison. ( the '.'  prints the top of the stack in these examples)
     buffer1 =" ABCDEFG"  ok
     buffer2 =" ABCDEFG"  ok

     buffer1 buffer2 STR= .  ( should be -1, TRUE flag) -1  ok

     string1 buffer1 str> .  ( should be  0) 0  ok
     string1 buffer1 str< .  ( should be -1) -1  ok


\ 4. String cloning and copying
     string1 buffer1 COPYSTR  ok

     string1 writestr Now is the time for all good men to come to the aid  ok
     buffer1 writestr Now is the time for all good men to come to the aid  ok


\ 5. Check if a string is empty
     buffer1 len . 55  ok
     buffer1 =""           \ assign null string  ok
     buffer1 len . 0  ok



\ 6. Append a byte to a string
     buffer2 =" Append this"  ok
     buffer2 writestr Append this
 ok
     char !  buffer2 APPEND-CHAR  ok
     buffer2 writestr Append this!
 ok
hex  ok
     0A buffer2 APPEND-CHAR     \ append a raw carriage return  ok
     0D buffer2 APPEND-CHAR     \ append a raw line-feed  ok
  ok
     buffer2 writestr Append this!

 ok
\ we see the extra line before OK so Appending binary chars worked

 decimal ok

\ 7. Extract a substring from a string. Result placed in a temp buffer automagically

     string1 writestr Now is the time for all good men to come to the aid ok

     string1 5 11 substr writestr is the time ok


\ 8. Replace every occurrence of a byte (or a string) in a string with another string
\    BL is a system constant for "Blank" ie the space character (HEX 020)

     buffer1 =" This*string*is*full*of*stars*"  ok
  ok
     BL  char *  buffer1 REPLACE-CHAR  ok
     buffer1 writestr This string is full of stars
 ok


\ 9. Join strings
     buffer1 =" James "  ok
     buffer2 =" Alexander"  ok
     buffer2 buffer1 CONCAT  ok
  ok
     buffer1 writestr James Alexander
 ok
