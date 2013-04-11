0 VALUE vials
0 VALUE ampules
0 VALUE bars
0 VALUE bag	

#250   3 /  #250 #25 /   MIN 1+ CONSTANT maxvials	
#250    2/  #250 #15 /   MIN 1+ CONSTANT maxampules
#250 #20 /  #250    2/   MIN 1+ CONSTANT maxbars	

: RESULTS ( v a b -- k )
	3DUP #20 *  SWAP 2*      +  SWAP     3 * +  #250 > IF  3DROP -1 EXIT  ENDIF
	3DUP    2*  SWAP #15   * +  SWAP   #25 * +  #250 > IF  3DROP -1 EXIT  ENDIF
	#2500    *  SWAP #1800 * +  SWAP #3000 * + ;

: .SOLUTION ( -- )
	CR ." The traveller's knapsack contains "
	   vials   DEC. ." vials of panacea, "
	   ampules DEC. ." ampules of ichor, "
	CR bars    DEC. ." bars of gold, a total value of "
	   vials ampules bars RESULTS 0DEC.R ." ." ;

: KNAPSACK ( -- )
	-1 TO bag
	maxvials 0 ?DO
	maxampules 0 ?DO
	     maxbars 0 ?DO
                              K J I RESULTS DUP
			    bag  > IF  TO bag  K TO vials J TO ampules I TO bars
				ELSE  DROP
			        ENDIF
		     LOOP
		   LOOP
		 LOOP
	.SOLUTION ;
