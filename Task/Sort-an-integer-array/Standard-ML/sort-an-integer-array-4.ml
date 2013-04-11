- load "Listsort";
> val it = () : unit
- load "Int";
> val it = () : unit
- val nums = [2, 4, 3, 1, 2];
> val nums = [2, 4, 3, 1, 2] : int list
- val sorted = Listsort.sort Int.compare nums;
> val sorted = [1, 2, 2, 3, 4] : int list
