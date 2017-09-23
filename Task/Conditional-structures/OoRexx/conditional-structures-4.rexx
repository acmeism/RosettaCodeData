                     /*the  WHEN  conditional operators are the same as */
                     /*the   IF   conditional operators.                */

  select
  when t<0       then z=abs(u)
  when t=0 & y=0 then z=0
  when t>0       then do
                      y=sqrt(z)
                      z=u**2
                      end

                /*if control reaches this point  and  none of the WHENs */
                /*were satisfiied, a SYNTAX condition is raised (error).*/
  end
