: >file ( string len filename len -- )
   w/o create-file throw dup >r write-file throw r> close-file throw ;

s" This is a string." s" file.txt" >file
