*      *> Using a '&'.
       01  Long-Str-Val     PIC X(200) VALUE "Lorem ipsum dolor sit "
           & "amet, consectetuer adipiscing elit, sed diam nonummy "
           & "nibh euismod tincidunt ut laoreet dolore magna aliquam "
           & "erat volutpat.".

*      *> Using a '-' in column 7. Note the first two literals have no
*      *> closing quotes.
       01  Another-Long-Str PIC X(200) VALUE " Ut wisi enim ad minim
      -    "veniam, quis nostrud exerci tation ullamcorper suscipit
      -    "lobortis nisl ut aliquip ex ea commodo consequat".
