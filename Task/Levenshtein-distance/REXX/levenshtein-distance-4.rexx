call test 'kitten'      ,'sitting'
call test 'rosettacode' ,'raisethysword'
call test 'Sunday'      ,'Saturday'
call test 'Vladimir_Levenshtein[1965]',,
          'Vladimir_Levenshtein[1965]'
call test 'this_algorithm_is_similar_to',,
          'Damerau-Levenshtein_distance'
call test '','abc'
Exit

test: Procedure
  Parse Arg s,t
  ld.=''
  Say '          1st string  = >'s'<'
  Say '          2nd string  = >'t'<'
  Say 'Levenshtein distance  =' LevenshteinDistance(s,length(s),t,length(t))
  Say ''
  Return

LevenshteinDistance: Procedure Expose ld.
-- sl and tl are the number of characters in string s and t respectively
  Parse Arg s,sl,t,tl
  If ld.sl.tl<>'' Then
    Return ld.sl.tl
  Select
    When sl=0 Then ld.sl.tl=tl
    When tl=0 Then ld.sl.tl=sl
    Otherwise Do
      /* test if last characters of the strings match */
      cost=substr(s,sl,1)<>substr(t,tl,1)
      /* return minimum of delete char from s, delete char from t,
         and delete char from both */
      ld.sl.tl=min(LevenshteinDistance(s,sl-1,t,tl  )+1,,
                   LevenshteinDistance(s,sl  ,t,tl-1)+1,,
                   LevenshteinDistance(s,sl-1,t,tl-1)+cost)
      End
    End
  Return ld.sl.tl
