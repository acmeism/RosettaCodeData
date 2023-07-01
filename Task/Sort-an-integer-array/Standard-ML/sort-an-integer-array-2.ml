- load "Arraysort";
> val it = () : unit
- load "Int";
> val it = () : unit
- val nums = Array.fromList [2, 4, 3, 1, 2];
> val nums = <array> : int array
- Arraysort.sort Int.compare nums;
> val it = () : unit
- Array.foldr op:: [] nums;
> val it = [1, 2, 2, 3, 4] : int list
