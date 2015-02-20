                      /*the  WHEN  conditional operators are the same as*/
                      /*the   IF   conditional operators.               */
 select
 when t<0        then z=abs(u)
 when t=0 & y=0  then z=0
 when t>0        then do
                      y=sqrt(z)
                      z=u**2
                      end

                      /*if control reaches here & none of the WHENs were*/
                      /*satisfiied, a SYNTAX (error) condition is raised*/
 end  /*1st select*/

     select
     when a=='angel'              then many='host'
     when a=='ass' | a=='donkey'  then many='pace'
     when a=='crocodile'          then many='bask'
     when a=='crow'               then many='murder'
     when a=='lark'               then many='ascension'
     when a=='quail'              then many='bevy'
     when a=='wolf'               then many='pack'
     otherwise                         many='?'
     end  /*2nd select*/          /* [↑]  uses OTHERWISE as a catch-all.*/
