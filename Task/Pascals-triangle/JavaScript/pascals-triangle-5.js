const aux = n => {
  if(n <= 1) return [1]
  const prevLayer = aux(n - 1)
  const shifted = [0, ...prevLayer]
  return shifted.map((x, i) => (prevLayer[i] || 0) + x)
}
const pascal = n => {
  for(let i = 1; i <= n; i++) {
    console.log(aux(i).join(' '))
  }
}
pascal(8)
