BEGIN CO plot Tupper's self-referential formula
            need to find x, y such that:
              1/2 < floor( mod( (y/17)*2^ - ( 17x - mod(y,17) ), 2 ) )
            where x in 0..106, y in k..k+16
       CO
    PR precision 600 PR
    LONG LONG INT k = 960 939 379 918 958 884 971 672 962 127 852 754 715 004 339 660 129 306 651 505
                      519 271 702 802 395 266 424 689 642 842 174 350 718 121 267 153 782 770 623 355
                      993 237 280 874 144 307 891 325 963 941 337 723 487 857 735 749 823 926 629 715
                      517 173 716 995 165 232 890 538 221 612 403 238 855 866 184 013 235 585 136 048
                      828 693 337 902 491 454 229 288 667 081 096 184 496 091 705 183 454 067 827 731
                      551 705 405 381 627 380 967 602 565 625 016 981 482 083 418 783 163 849 115 590
                      225 610 003 652 351 370 343 874 461 848 378 737 238 198 224 849 863 465 033 159
                      410 054 974 700 593 138 339 226 497 249 461 751 545 728 366 702 369 745 461 014
                      655 997 933 798 537 483 143 786 841 806 593 422 227 898 388 722 980 000 748 404
                      719;

    INT k mod 17 = SHORTEN SHORTEN ( k MOD 17 );
    FOR y delta FROM 0 TO 16 DO
        FOR x FROM 106 BY -1 TO 0 DO
            INT power of 2   = - ( 17 * x ) - ( k mod 17 + y delta ) MOD 17;
            # if power of 2 = 0, then ( v * 2 ^ power of 2 ) MOD 2 = v MOD 2 #
            # if power of 2 > 0, then ( v * 2 ^ power of 2 ) MOD 2 = 0       #
            IF power of 2 > 0 THEN
                print( ( " " ) )
            ELSE
                LONG LONG INT v := ( k + y delta ) OVER 17;
                IF power of 2 < 0 THEN
                    v OVERAB LONG LONG 2 ^ ABS power of 2
                FI;
                print( ( IF ODD v THEN "#" ELSE " " FI ) )
            FI
        OD;
        print( ( newline ) )
    OD
END
