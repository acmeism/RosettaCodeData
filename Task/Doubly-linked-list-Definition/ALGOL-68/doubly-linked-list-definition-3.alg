#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #
MODE VALUE = STRING; # user defined data type #
PR READ "prelude/Doubly-linked_list_Link.a68" PR;
PR READ "prelude/Doubly-linked_list_Operator.a68" PR;

main: (

    []VALUE sample = ("Was", "it", "a", "cat", "I", "saw");
    LIST example list := LISTINIT HEAP LISTNEW;
    LINK this;

# Add some data to a list #
    FOR i TO UPB sample DO
        this := HEAP LINKNEW;
        value OF this := sample[i];
        TAIL example list +:= this
    OD;

# Iterate throught the list forward #
    this := HEAD example list;
    print("Iterate forward: ");
    WHILE this ISIN example list DO
        print((value OF this, " "));
        this := next OF this
    OD;
    print(new line);

# Iterate throught the list backward #
    this := TAIL example list;
    print("Iterate backward: ");
    WHILE this ISIN example list DO
        print((value OF this, " "));
        this := prev OF this
    OD;
    print(new line);

# Finally empty the list #
    print("Empty from tail: ");
    WHILE NOT ISEMPTY example list DO
          this := (example list -:= TAIL example list);
          print((value OF this, " "))
    OD;
    print(new line)
)
