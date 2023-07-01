/*
== equal value
=== equal value and equal type
!= not equal value
!== not equal value or not equal type
< lexically ordered before
> lexically ordered after
*/

console.log(
"abcd" == "abcd", // true
"abcd" === "abcd", // true
123 == "123", // true
123 === "123", // false
"ABCD" == "abcd", // false
"ABCD" != "abcd", // true
123 != "123", // false
123 !== "123", // true
"abcd" < "dcba", // true
"abcd" > "dcba", // false
"ABCD".toLowerCase() == "abcd".toLowerCase(), // true (case insensitive)
)
