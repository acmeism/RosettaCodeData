let median = (arr) =>
{
    let float_compare = (a, b) => {
      let diff = a -. b
      if diff == 0.0 { 0 } else
      if diff > 0.0 { 1 } else { -1 }
    }
    let _ = Js.Array2.sortInPlaceWith(arr, float_compare)
    let count = Js.Array.length(arr)
    // find the middle value, or the lowest middle value
    let middleval = ((count - 1) / 2)
    let median =
      if (mod(count, 2) != 0) { // odd number, middle is the median
          arr[middleval]
      } else { // even number, calculate avg of 2 medians
          let low = arr[middleval]
          let high = arr[middleval+1]
          ((low +. high) /. 2.0)
      }
    median
}

Js.log(median([4.1, 5.6, 7.2, 1.7, 9.3, 4.4, 3.2]))
Js.log(median([4.1, 7.2, 1.7, 9.3, 4.4, 3.2]))
