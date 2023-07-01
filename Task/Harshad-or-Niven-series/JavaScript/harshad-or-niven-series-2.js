function* harshads (start) {
  for (let n = start; true; n++) {
    const sum = [...n.toString()].map(Number).reduce((a, b) => a + b)
    if (n % sum === 0) {
      yield n
    }
  }
}

const first20 = (() => {
  const hs = harshads(1)
  return [...Array(20)].map(() => hs.next().value)
})()
console.log("First 20:", ...first20)

const firstAfter1000 = harshads(1001).next().value
console.log("First after 1000:", firstAfter1000)
