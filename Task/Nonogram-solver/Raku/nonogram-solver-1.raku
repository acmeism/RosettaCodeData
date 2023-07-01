# 20220401 Raku programming solution

sub reduce(\a, \b) {
   my \countRemoved = $ = 0;
   for ^+a -> \i {
      my \commonOn  = @ =  True xx b.elems;
      my \commonOff = @ = False xx b.elems;

      a[i].map: -> \candidate { commonOn  <<?&=>> candidate ;
                                commonOff <<?|=>> candidate }
      # remove from b[j] all candidates that don't share the forced values
      for ^+b -> \j {
         my (\fi,\fj) = i, j;
         for ((+b[j])^...0) -> \k {
            my \cnd = b[j][k];
            if (commonOn[fj] ?& !cnd[fi]) ?| (!commonOff[fj] ?& cnd[fi]) {
	       b[j][k..*-2] = b[j][k+1..*-1];
               b[j].pop;
               countRemoved++
            }
         }
         return -1 if b[j].elems == 0
      }
   }
   return countRemoved
}

sub genSequence(\ones, \numZeros) {
   if ( my \le = ones.elems ) == 0 { return [~] '0' xx numZeros }

   my @result;
   loop ( my $x = 1; $x < ( numZeros -le+2); $x++ ) {
      my @skipOne = ones[1..*];
      for genSequence(@skipOne, numZeros -$x) -> \tail {
         @result.push:  ( '0' x $x )~ones[0]~tail
      }
   }
   return @result
}

# If all the candidates for a row have a value in common for a certain cell,
#   then it's the only possible outcome, and all the candidates from the
#   corresponding column need to have that value for that cell too. The ones
#   that don't, are removed. The same for all columns. It goes back and forth,
#   until no more candidates can be removed or a list is empty (failure).

sub reduceMutual(\cols, \rows) {
   return -1 if ( my \countRemoved1 = reduce(cols, rows) ) == -1 ;
   return -1 if ( my \countRemoved2 = reduce(rows, cols) ) == -1 ;

   return countRemoved1 + countRemoved2
}

# collect all possible solutions for the given clues
sub getCandidates(@data, \len) {
   return gather for @data -> \s {
      my \sumBytes = [+] (my @a = s.ords)>>.&{ $_ - 'A'.ord + 1 }
      my @prep = @a.values.map: { [~] '1' xx ($_ - 'A'.ord + 1) }
      take ( gather for genSequence(@prep, len -sumBytes+1) -> \r {
         my \bits = r.substr(1..*).ords;
	 take ( bits.values.map: *.chr == '1' ).Array
      } ).Array
   }
}

sub  newPuzzle (@data) {

   my (@rowData,@colData) := @data.map: *.split: ' ' ;

   my \rows = getCandidates(@rowData, @colData.elems);
   my \cols = getCandidates(@colData, @rowData.elems);

   loop {
      my \numChanged = reduceMutual(cols, rows);
      given (numChanged) { when -1 { say "No solution" andthen return }
                           when  0 { last }                             }
   }

   for rows -> \row {
      for ^+cols -> \k { print row[0][k] ?? '# ' !! '. ' }
      print "\n"
   }
   print "\n"
}

newPuzzle $_ for (
   ( "C BA CB BB F AE F A B", "AB CA AE GA E C D C" ),

   ( "F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC",
     "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA" ),

   ( "CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH "
       ~"BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC",
     "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF "
        ~"AAAAD BDG CEF CBDB BBB FC" ),

   ( "E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G",
     "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ "
        ~"ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM" ),
);
