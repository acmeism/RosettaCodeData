// Arrays, in V (Vlang)
// Tectonics: v run arrays.v
module main

// A little bit about V variables.  V does not allow uninitialized data.
// If an identifier exists, there is a valid value.  "Empty" arrays have
// values in all positions, and V provides defaults for base types if not
// explicitly specified. E.g. 0 for numbers, `0` for rune, "" for strings.

// V uses := for definition and initialization, and = for assignment

// starts here, V programs start by invoking the "main" function.
pub fn main() {

   // Array definition in source literal form (immutable)
   array := [1,2,3,4]
   // print first element, 0 relative indexing
   println("array: $array")
   println("array[0]: ${array[0]}")
   // immutable arrays cannot be modified after initialization
   // array[1] = 5, would fail to compile with a message it needs mut

   // Dynamic arrays have some property fields
   println("array.len: $array.len")
   println("array.cap: $array.cap")

   // array specs are [n]type{properties}
   // Dynamic array definition, initial default values, "" for string
   mut array2 := []string{}
   // Append an element, using lessless
   array2 << "First"
   println("array2[0]: ${array2[0]}")
   println("array2.len: $array2.len")
   println("array2.cap: $array2.cap")

   // Fixed array definition, capacity is fixed (! suffix), mutable entries
   mut array3 := ["First", "Second", "Third"]!
   println("array3: $array3")
   array3[array3.len-1] = "Last"
   println("array3: $array3")
   println("array3.len: $array3.len")

   // Advanced, array intiailization using non default value
   mut array4 := [4]int{init: 42}
   array4[2] = 21
   println("array4: $array4")

   // Arrays can be sliced, creating a copy
   mut array5 := array4[0..3]
   println("array5: $array5")
   array5[2] = 10
   println("array4: $array4")
   println("array5: $array5")
}
