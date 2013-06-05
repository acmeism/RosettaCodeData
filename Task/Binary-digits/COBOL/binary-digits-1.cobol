IDENTIFICATION DIVISION.
       PROGRAM-ID. SAMPLE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

         01 binary_number   pic X(21).
         01 str             pic X(21).
         01 binary_digit    pic X.
         01 digit           pic 9.
         01 n               pic 9(7).
         01 nstr            pic X(7).

       PROCEDURE DIVISION.
         accept nstr
         move nstr to n
         perform until n equal 0
           divide n by 2 giving n remainder digit
           move digit to binary_digit
           string binary_digit  DELIMITED BY SIZE
                  binary_number DELIMITED BY SPACE
                  into str
           move str to binary_number
         end-perform.
         display binary_number
         stop run.
