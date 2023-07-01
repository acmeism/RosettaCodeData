jortSort: Parse Arg list
/*---------------------------------------------------------------------
* Determine if list is sorted
* << is used to avoid numeric comparison
* 3 4e-1 is sorted
*--------------------------------------------------------------------*/
Do i=2 To words(list)
  If word(list,i)<<word(list,i-1) Then
    Leave
  End
Return (i=words(list)+1)|(list='')
