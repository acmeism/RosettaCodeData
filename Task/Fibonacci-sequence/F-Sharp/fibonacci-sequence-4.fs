open System
open System.Diagnostics
open System.Numerics

/// Finds the highest power of two which is less than or equal to a given input.
let inline prevPowTwo (x : int) =
    let mutable n = x
    n <- n - 1
    n <- n ||| (n >>> 1)
    n <- n ||| (n >>> 2)
    n <- n ||| (n >>> 4)
    n <- n ||| (n >>> 8)
    n <- n ||| (n >>> 16)
    n <- n + 1
    match x with
    | x when x = n -> x
    | _ -> n/2

/// Evaluates the nth Fibonacci number using matrix arithmetic and
/// exponentiation by squaring.
let crazyFib (n : int) =
    let powTwo = prevPowTwo n

    /// Applies 2n rule repeatedly until another application of the rule would
    /// go over the target value (or the target value has been reached).
    let rec iter1 i q r s =
        match i with
        | i when i < powTwo ->
            iter1 (i*2) (q*q + r*r) (r * (q+s)) (r*r + s*s)
        | _ -> i, q, r, s

    /// Applies n+1 rule until the target value is reached.
    let rec iter2 (i, q, r, s) =
        match i with
        | i when i < n ->
            iter2 ((i+1), (q+r), q, r)
        | _ -> q

    match n with
    | 0 -> 1I
    | _ ->
        iter1 1 1I 1I 0I
        |> iter2
