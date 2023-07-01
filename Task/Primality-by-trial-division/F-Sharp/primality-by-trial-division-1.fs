open NUnit.Framework
open FsUnit
let inline isPrime n = not ({uint64 2..uint64 (sqrt (double n))} |> Seq.exists (fun (i:uint64) -> uint64 n % i = uint64 0))
[<Test>]
let ``Validate that 2 is prime`` () =
  isPrime 2 |> should equal true

[<Test>]
let ``Validate that 4 is not prime`` () =
  isPrime 4 |> should equal false

[<Test>]
let ``Validate that 3 is prime`` () =
  isPrime 3 |> should equal true

[<Test>]
let ``Validate that 9 is not prime`` () =
  isPrime 9 |> should equal false

[<Test>]
let ``Validate that 5 is prime`` () =
  isPrime 5 |> should equal true

[<Test>]
let ``Validate that 277 is prime`` () =
  isPrime 277 |> should equal true
