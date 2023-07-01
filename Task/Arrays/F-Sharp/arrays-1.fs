> Array.create 6 'A';;
val it : char [] = [|'A'; 'A'; 'A'; 'A'; 'A'; 'A'|]
> Array.init 8 (fun i -> i * 10) ;;
val it : int [] = [|0; 10; 20; 30; 40; 50; 60; 70|]
> let arr = [|0; 1; 2; 3; 4; 5; 6 |] ;;
val arr : int [] = [|0; 1; 2; 3; 4; 5; 6|]
> arr.[4];;
val it : int = 4
> arr.[4] <- 65 ;;
val it : unit = ()
> arr;;
val it : int [] = [|0; 1; 2; 3; 65; 5; 6|]
