 Call random ,,1234567
 a=.array~new
 b=.array~new
 Do i=1 To 10
   a[i]=random(1,9999)
   End
 Say 'Unfiltered values:' a~makestring(line,' ')
 /* copy even numbers to array b */
 j=0
 Do i=1 to 10
   If filter(a[i]) Then Do
     j = j + 1
     b[j]=a[i]
     End
   end
 Say 'Filtered values (in second array):      ' b~makestring(line,' ')
 /* destructive filtering: copy within array a */
 j=0
 Do i=1 to 10
   If filter(a[i]) Then Do
     j = j + 1
     a[j]=a[i]
     End
   end
 /* destructive filtering: delete the remaining elements */
 Do i=10 To j+1 By -1
   a~delete(i)
   End
 Say 'Filtered values (destructive filtering):' a~makestring(line,' ')
 Exit
 filter: Return arg(1)//2=0
