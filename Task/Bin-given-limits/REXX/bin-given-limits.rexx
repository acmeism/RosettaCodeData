/*REXX program counts how many   numbers of a set   that fall in the range of each bin. */
lims= 23 37 43 53 67 83                          /* ◄■■■■■■1st set of bin limits & data.*/
data= 95 21 94 12 99 4 70 75 83 93 52 80 57 5 53 86 65 17 92 83 71 61 54 58 47  ,
      16 8 9 32 84 7 87 46 19 30 37 96 6 98 40 79 97 45 64 60 29 49 36 43 55
call lims lims;     call bins data
call show 'the 1st set of bin counts for the specified data:'
                                                                  say;    say;    say
lims=  14  18 249 312 389 392 513 591 634 720    /* ◄■■■■■■2nd set of bin limits & data.*/
data= 445 814 519 697 700 130 255 889 481 122 932  77 323 525 570 219 367 523 442 933  ,
      416 589 930 373 202 253 775  47 731 685 293 126 133 450 545 100 741 583 763 306  ,
      655 267 248 477 549 238  62 678  98 534 622 907 406 714 184 391 913  42 560 247  ,
      346 860  56 138 546  38 985 948  58 213 799 319 390 634 458 945 733 507 916 123  ,
      345 110 720 917 313 845 426   9 457 628 410 723 354 895 881 953 677 137 397  97  ,
      854 740  83 216 421  94 517 479 292 963 376 981 480  39 257 272 157   5 316 395  ,
      787 942 456 242 759 898 576  67 298 425 894 435 831 241 989 614 987 770 384 692  ,
      698 765 331 487 251 600 879 342 982 527 736 795 585  40  54 901 408 359 577 237  ,
      605 847 353 968 832 205 838 427 876 959 686 646 835 127 621 892 443 198 988 791  ,
      466  23 707 467  33 670 921 180 991 396 160 436 717 918   8 374 101 684 727 749
call lims lims;     call bins data
call show 'the 2nd set of bin counts for the specified data:'
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bins: parse arg nums; !.= 0;  datum= words(nums);  wc= length(datum)  /*max width count.*/
        do   j=1  for datum;  x= word(nums, j)
          do k=0  for #                          /*find the bin that this number is in. */
          if x < @.k  then do;  !.k= !.k + 1;  iterate j;  end        /*bump a bin count*/
          end   /*k*/
                                !.k= !.k + 1     /*number is > the highest bin specified*/
        end     /*j*/;                   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
lims: parse arg limList;  #= words(limList);                 wb= 0    /*max width binLim*/
        do j=1  for #;  _= j - 1;   @._= word(limList, j);   wb= max(wb, length(@._) )
        end   /*j*/;                     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg t;    say center(t,  51     );   $= left('', 9)  /*$:    for indentation*/
                      say center('', 51, "═")                    /*show title separator.*/
                          jp= # - 1;        ge= '≥';              le='<'; eq= '   count='
        do j=0  for #;    jm= j - 1;  bin= right(@.j, wb)
        if j==0  then say $ left('', length(ge) +3+wb+length(..) )le bin eq right(!.j, wc)
                 else say $                 ge right(@.jm, wb) .. le bin eq right(!.j, wc)
        if j==jp  then say $ ge right(@.jp,wb) left('', 3+length(..)+wb) eq right(!.#, wc)
        end   /*j*/;                     return
