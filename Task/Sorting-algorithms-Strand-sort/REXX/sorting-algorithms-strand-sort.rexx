/*REXX program sorts a random list of words (or numbers)              */
/* using the strand sort algorithm                                    */
Parse Arg size minv maxv old      /* obtain optional arguments from CL*/
if size=='' | size==","  then size=20    /*Not specified? use default.*/
if minv=='' | minv==","  then minv= 0    /*Not specified? use default.*/
if maxv=='' | maxv==","  then maxv=size  /*Not specified? use default.*/
Do i=1 To size
  old=old random(0,maxv-minv)+minv/* append random numbers to the list*/
  End
old=space(old)
Say 'Unsorted list:'
Say old
new=strand_sort(old)  /* sort given list (extended by random numbers) */
Say
Say 'Sorted list:'
Say new
Exit                           /* stick a fork in it,  we're all done */
/*--------------------------------------------------------------------*/
strand_sort: Procedure
  Parse Arg source
  sorted=''
  Do While words(source)\==0
    w=words(source)
    /* Find first word in source that is smaller Than its predecessor */
    Do j=1 To w-1
      If word(source,j)>word(source,j+1) Then
        Leave
      End
    /* Elements source.1 trough source.j are in ascending order       */
    head=subword(source,1,j)
    source=subword(source,j+1)     /* the rest starts with a smaller  */
                                   /* value or is empty (j=w!)        */
    sorted=merge(sorted,head)
    End
  Return sorted
/*--------------------------------------------------------------------*/
merge: Procedure
  Parse Arg a.1,a.2
  p=''
  Do Forever
    w1=words(a.1)
    w2=words(a.2)
    Select
      When w1==0 | w2==0 Then
        Return space(p a.1 a.2)
      When word(a.1,w1)<=word(a.2,1) Then
        Return space(p a.1 a.2)
      When word(a.2,w2)<=word(a.1,1) Then
        Return space(p a.2 a.1)
      Otherwise Do
        nn=1+(word(a.1,1)>=word(a.2,1))
        /* move the smaller first word of a.1 or a.2 to p */
        p=p word(a.nn,1)
        a.nn=subword(a.nn,2)
        End
      End
    End
