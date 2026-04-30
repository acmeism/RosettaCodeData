generic
   type Result_Type (<>) is limited private;
   None: Result_Type;
   with function One(X: Positive) return Result_Type;
   with function Add(X, Y: Result_Type) return Result_Type
      is <>;
package Generic_Divisors is

  function Process
    (N: Positive; First: Positive := 1) return Result_Type is
      (if First**2 > N or First = N then None
      elsif (N mod First)=0 then
	(if First = 1 or First*First = N
	   then Add(One(First), Process(N, First+1))
	   else Add(One(First),
		    Add(One((N/First)), Process(N, First+1))))
      else Process(N, First+1));

end Generic_Divisors;
