const patienceSort = (nums) => {
  const piles = []

  for (let i = 0; i < nums.length; i++) {
    const num = nums[i]
    const destinationPileIndex = piles.findIndex(
      (pile) => num >= pile[pile.length - 1]
    )
    if (destinationPileIndex === -1) {
      piles.push([num])
    } else {
      piles[destinationPileIndex].push(num)
    }
  }

  for (let i = 0; i < nums.length; i++) {
    let destinationPileIndex = 0
    for (let p = 1; p < piles.length; p++) {
      const pile = piles[p]
      if (pile[0] < piles[destinationPileIndex][0]) {
        destinationPileIndex = p
      }
    }
    const distPile = piles[destinationPileIndex]
    nums[i] = distPile.shift()
    if (distPile.length === 0) {
      piles.splice(destinationPileIndex, 1)
    }
  }

  return nums
}
console.log(patienceSort([10,6,-30,9,18,1,-20]));
