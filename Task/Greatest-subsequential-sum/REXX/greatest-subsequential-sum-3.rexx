/* REXX ***************************************************************
* 09.08.2012 Walter Pachl translated Pascal algorithm to Rexx
**********************************************************************/
  s=' -1 -2  3  5  6 -2 -1  4 -4  2 -1'
  maxSum   = 0
  seqStart = 0
  seqEnd   = -1
  do i = 1 To words(s)
    seqSum = 0
    Do j = i to words(s)
      seqSum = seqSum + word(s,j)
      if seqSum > maxSum then Do
        maxSum   = seqSum
        seqStart = i
        seqEnd   = j
        end
      end
    end
  Say 'Sequence:'
  Say s
  Say 'Subsequence with greatest sum: '
  If seqend<seqstart Then
    Say 'empty'
  Else Do
    ol=copies('   ',seqStart-1)
    Do i = seqStart to seqEnd
      ol=ol||right(word(s,i),3)
      End
    Say ol
    Say 'Sum:' maxSum
    End
