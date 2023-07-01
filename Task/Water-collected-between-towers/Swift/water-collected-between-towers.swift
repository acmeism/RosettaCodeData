// Based on this answer from Stack Overflow:
// https://stackoverflow.com/a/42821623

func waterCollected(_ heights: [Int]) -> Int {
    guard heights.count > 0 else {
        return 0
    }
    var water = 0
    var left = 0, right = heights.count - 1
    var maxLeft = heights[left], maxRight = heights[right]

    while left < right {
        if heights[left] <= heights[right] {
            maxLeft = max(heights[left], maxLeft)
            water += maxLeft - heights[left]
            left += 1
        } else {
            maxRight = max(heights[right], maxRight)
            water += maxRight - heights[right]
            right -= 1
        }
    }
    return water
}

for heights in [[1, 5, 3, 7, 2],
                [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
                [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
                [5, 5, 5, 5],
                [5, 6, 7, 8],
                [8, 7, 7, 6],
                [6, 7, 10, 7, 6]] {
    print("water collected = \(waterCollected(heights))")
}
