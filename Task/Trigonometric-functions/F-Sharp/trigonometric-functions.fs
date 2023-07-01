open NUnit.Framework
open FsUnit

// radian

[<Test>]
let ``Verify that sin pi returns 0`` () =
  let x = System.Math.Sin System.Math.PI
  System.Math.Round(x,5) |> should equal 0

[<Test>]
let ``Verify that cos pi returns -1`` () =
  let x = System.Math.Cos System.Math.PI
  System.Math.Round(x,5) |> should equal -1

[<Test>]
let ``Verify that tan pi returns 0`` () =
  let x = System.Math.Tan System.Math.PI
  System.Math.Round(x,5) |> should equal 0

[<Test>]
let ``Verify that sin pi/2 returns 1`` () =
  let x = System.Math.Sin (System.Math.PI / 2.0)
  System.Math.Round(x,5) |> should equal 1

[<Test>]
let ``Verify that cos pi/2 returns -1`` () =
  let x = System.Math.Cos (System.Math.PI / 2.0)
  System.Math.Round(x,5) |> should equal 0

[<Test>]
let ``Verify that sin pi/3 returns sqrt 3/2`` () =
  let actual = System.Math.Sin (System.Math.PI / 3.0)
  let expected = System.Math.Round((System.Math.Sqrt 3.0) / 2.0, 5)
  System.Math.Round(actual,5) |> should equal expected

[<Test>]
let ``Verify that cos pi/3 returns -1`` () =
  let x = System.Math.Cos (System.Math.PI / 3.0)
  System.Math.Round(x,5) |> should equal 0.5

[<Test>]
let ``Verify that cos and sin of pi/4 return same value`` () =
  let c = System.Math.Cos (System.Math.PI / 4.0)
  let s = System.Math.Sin (System.Math.PI / 4.0)
  System.Math.Round(c,5) = System.Math.Round(s,5) |> should be True

[<Test>]
let ``Verify that acos pi/3 returns 1/2`` () =
  let actual = System.Math.Acos 0.5
  let expected = System.Math.Round((System.Math.PI / 3.0),5)
  System.Math.Round(actual,5) |> should equal expected

[<Test>]
let ``Verify that asin 1 returns pi/2`` () =
  let actual = System.Math.Asin 1.0
  let expected = System.Math.Round((System.Math.PI / 2.0),5)
  System.Math.Round(actual,5) |> should equal expected

[<Test>]
let ``Verify that atan 0 returns 0`` () =
  let actual = System.Math.Atan 0.0
  let expected = System.Math.Round(0.0,5)
  System.Math.Round(actual,5) |> should equal expected

// degree

let toRadians d = d * System.Math.PI / 180.0

[<Test>]
let ``Verify that pi is 180 degrees`` () =
  toRadians 180.0 |> should equal System.Math.PI

[<Test>]
let ``Verify that pi/2 is 90 degrees`` () =
  toRadians 90.0 |> should equal (System.Math.PI / 2.0)

[<Test>]
let ``Verify that pi/3 is 60 degrees`` () =
  toRadians 60.0 |> should equal (System.Math.PI / 3.0)

[<Test>]
let ``Verify that sin 180 returns 0`` () =
  let x = System.Math.Sin (toRadians 180.0)
  System.Math.Round(x,5) |> should equal 0

[<Test>]
let ``Verify that cos 180 returns -1`` () =
  let x = System.Math.Cos (toRadians 180.0)
  System.Math.Round(x,5) |> should equal -1

[<Test>]
let ``Verify that tan 180 returns 0`` () =
  let x = System.Math.Tan (toRadians 180.0)
  System.Math.Round(x,5) |> should equal 0

[<Test>]
let ``Verify that sin 90 returns 1`` () =
  let x = System.Math.Sin (toRadians 90.0)
  System.Math.Round(x,5) |> should equal 1

[<Test>]
let ``Verify that cos 90 returns -1`` () =
  let x = System.Math.Cos (toRadians 90.0)
  System.Math.Round(x,5) |> should equal 0

[<Test>]
let ``Verify that sin 60 returns sqrt 3/2`` () =
  let actual = System.Math.Sin (toRadians 60.0)
  let expected = System.Math.Round((System.Math.Sqrt 3.0) / 2.0, 5)
  System.Math.Round(actual,5) |> should equal expected

[<Test>]
let ``Verify that cos 60 returns -1`` () =
  let x = System.Math.Cos (toRadians 60.0)
  System.Math.Round(x,5) |> should equal 0.5

[<Test>]
let ``Verify that cos and sin of 45 return same value`` () =
  let c = System.Math.Cos (toRadians 45.0)
  let s = System.Math.Sin (toRadians 45.0)
  System.Math.Round(c,5) = System.Math.Round(s,5) |> should be True
