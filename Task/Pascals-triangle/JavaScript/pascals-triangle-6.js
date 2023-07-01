const aux = (() => {
  const layers = [[1], [1]]
  return n => {
    if(layers[n]) return layers[n]
    const prevLayer = aux(n - 1)
    const shifted = [0, ...prevLayer]
    layers[n] = shifted.map((x, i) => (prevLayer[i] || 0) + x)
    return layers[n]
  }
})()
const pascal = n => {
  for(let i = 1; i <= n; i++) {
    console.log(aux(i).join(' '))
  }
}
pascal(8)
