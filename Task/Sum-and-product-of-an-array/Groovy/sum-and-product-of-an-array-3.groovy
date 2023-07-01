println ([1,2,3,4,5].inject([sum: 0, product: 1]) { result, value ->
    [sum: result.sum + value, product: result.product * value]})
