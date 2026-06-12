 /*--------------------------------------------------------------------
 * 04.11.2013 Walter Pachl translated from PL/I
 * Take samp samples of groups with gs persons and check
 *how many of the groups have at least match persons with same birthday
 *-------------------------------------------------------------------*/
 samp=100000
 lo='0 21 85 185 311 458'
 hi='0 25 89 189 315 462'
 Do match=2 To 6
   Say ' '
   Say samp' samples . Percentage of groups with at least',
            match ' matches'
   Say 'Group size'
   Do gs=word(lo,match) To word(hi,match)
     cnt.=0
     Do i=1 To samp
       ok=0
       arr.=0
       Do g=1 To gs
         r=random(1,365)
         arr.r=arr.r+1
         If arr.r=match Then
           ok=1
         End
       cnt.ok=cnt.ok+1
       End
     hits=cnt.1/samp
     If hits>=.5 Then arrow=' <-'
                 Else arrow=''
     Say format(gs,10) cnt.0 cnt.1 100*hits||'%'||arrow
     End
   End
