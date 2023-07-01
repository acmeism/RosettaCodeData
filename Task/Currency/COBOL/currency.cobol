       >>SOURCE FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. currency-example.

DATA DIVISION.
WORKING-STORAGE SECTION.
01  Burger-Price                        CONSTANT 5.50.
01  Milkshake-Price                     CONSTANT 2.86.
01  num-burgers                         PIC 9(18) VALUE 4000000000000000.
01  num-milkshakes                      PIC 9(18) VALUE 2.
01  tax                                 PIC 9(18)V99.
01  tax-edited                          PIC $(17)9.99.
01  Tax-Rate                            CONSTANT 7.65.
01  total                               PIC 9(18)V99.
01  total-edited                        PIC $(17)9.99.

PROCEDURE DIVISION.
    COMPUTE total rounded, total-edited rounded =
        num-burgers * Burger-Price + num-milkshakes * Milkshake-Price
    DISPLAY "Total before tax: " total-edited

    COMPUTE tax rounded, tax-edited rounded = total * (Tax-Rate / 100)
    DISPLAY "             Tax: " tax-edited

    ADD tax TO total GIVING total-edited rounded
    DISPLAY "  Total with tax: " total-edited
    .
END PROGRAM currency-example.
