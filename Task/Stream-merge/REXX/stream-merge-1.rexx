/* REXX ***************************************************************
* Merge 1.txt ... n.txt into all.txt
* 1.txt 2.txt 3.txt 4.txt
* 1     19    1999  2e3
* 17    33    2999  3000
* 8     500   3999              RC task STREAM MERGE
**********************************************************************/
done.=0                         /* done.i=1 indicates file exhausted */
p.=''                                  /* for test of sort error     */
Do i=1 By 1                            /* check files for existence  */
  f.i=i'.txt'
  If lines(f.i)=0 Then Leave
  Call get i                           /* and read first line of each*/
  End
n=i-1                                  /* we have n input files      */
done.0=n                               /* and all must be used       */
say n 'Input files'
oid='all.txt'
If lines(oid)>0 Then Do                /* output file exists         */
  Call lineout oid
  Do Until wordpos(answer,'Y N')>0
    Say 'file' oid 'exists. May it be replaced?'
    Pull answer
    End
  If answer='Y' Then
    'erase' oid
  Else Do
    Say 'Ok, we give up'
    Exit
    End
  End
say oid 'is the output file'           /* we'll create it now        */
Do Until done.0=0
  imin=0                               /* index of next source       */
  Do i=1 To n
    If done.i=0 Then Do                /* file i still in use        */
      If imin=0 Then Do                /* it's the first in this loop*/
        imin=i                         /* next source                */
        min=x.i                        /* element to be used         */
        End
      Else Do                          /* not the first              */
        If x.i<<min Then Do            /* avoid numerical comparison */
          imin=i                       /* next source                */
          min=x.i                      /* element to be used         */
          End
        End
      End
    End
  If imin<>0 Then Do                   /* found next source          */
    Call o x.imin                      /* use its element            */
    Call get imin                      /* get next element           */
                                       /* or set done.imin           */
    End
  Else                                 /* no more elements           */
    Call lineout oid                   /* close output file          */
  End
'type' oid
Exit

get: Procedure Expose f. x. p. done.
/*********************************************************************
* Get next element from file ii or set done.ii=1 if file is exhausted
*********************************************************************/
  Parse Arg ii
  If lines(f.ii)=0 Then Do             /* file ii is exhausted      */
    done.ii=1                          /* mark it as done           */
    done.0=done.0-1                    /* reduce number of files tbd*/
    End
  Else Do                              /* there's more in file ii   */
    x.ii=linein(f.ii)                  /* get next element (line)   */
    If x.ii<<p.ii Then Do              /* smaller than previous     */
      Say 'Input file' f.ii 'is not sorted ascendingly'
      Say p.ii 'precedes' x.ii         /* tell the user             */
      Exit                             /* and give up               */
      End
    p.ii=x.ii                          /* remember the element      */
    End
  Return

o: Return lineout(oid,arg(1))
