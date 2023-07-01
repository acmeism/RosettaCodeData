-val writeSegment = fn  L : {segment:BitArray.array, start:IntInf.int} list =>   fn NthSegment =>
		   let
		        val M=List.nth (L , NthSegment - 1 )
		   in
		        List.map (fn x=> x + #start M)  (map IntInf.fromInt (BitArray.getBits ( #segment M)) )
		   end;
- val primesInBits = segmentedSieve 2500000000 ;
val primesInBits =
  [{segment=-,start=1},{segment=-,start=120000001},
   {segment=-,start=240000001},{segment=-,start=360000001},
   {segment=-,start=480000001},..  <skipped> ,...]
  : {segment:BitArray.array, start:IntInf.int} list
- writeSegment primesInBits 21 ;
val it =
  [2400000011,2400000017,2400000023,2400000047,2400000061,2400000073,
   2400000091,2400000103,2400000121,2400000133,2400000137,2400000157,...]
  : IntInf.int list
- writeSegment primesInBits 1 ;
val it = [2,3,5,7,11,13,17,19,23,29,31,37,...] : IntInf.int list
