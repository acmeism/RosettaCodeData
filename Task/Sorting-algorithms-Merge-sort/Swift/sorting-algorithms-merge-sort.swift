// Merge Sort in Swift 4.2
// Source: https://github.com/raywenderlich/swift-algorithm-club/tree/master/Merge%20Sort
// NOTE: by use of generics you can make it sort arrays of any type that conforms to
//       Comparable protocol, however this is not always optimal

import Foundation

func mergeSort(_ array: [Int]) -> [Int] {
  guard array.count > 1 else { return array }

  let middleIndex = array.count / 2

  let leftPart = mergeSort(Array(array[0..<middleIndex]))
  let rightPart = mergeSort(Array(array[middleIndex..<array.count]))

  func merge(left: [Int], right: [Int]) -> [Int] {
    var leftIndex = 0
    var rightIndex = 0

    var merged = [Int]()
    merged.reserveCapacity(left.count + right.count)

    while leftIndex < left.count && rightIndex < right.count {
      if left[leftIndex] < right[rightIndex] {
        merged.append(left[leftIndex])
        leftIndex += 1
      } else if left[leftIndex] > right[rightIndex] {
        merged.append(right[rightIndex])
        rightIndex += 1
      } else {
        merged.append(left[leftIndex])
        leftIndex += 1
        merged.append(right[rightIndex])
        rightIndex += 1
      }
    }

    while leftIndex < left.count {
      merged.append(left[leftIndex])
      leftIndex += 1
    }

    while rightIndex < right.count {
      merged.append(right[rightIndex])
      rightIndex += 1
    }

    return merged
  }

  return merge(left: leftPart, right: rightPart)
}
