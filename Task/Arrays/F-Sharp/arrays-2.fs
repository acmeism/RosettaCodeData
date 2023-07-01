> let arr = new ResizeArray<int>();;
val arr : ResizeArray<int>
> arr.Add(42);;
val it : unit = ()
> arr.[0];;
val it : int = 42
> arr.[0] <- 13;;
val it : unit = ()
> arr.[0];;
val it : int = 13
> arr.[1];;
> System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index ...
> arr;;
val it : ResizeArray<int> = seq [13]
