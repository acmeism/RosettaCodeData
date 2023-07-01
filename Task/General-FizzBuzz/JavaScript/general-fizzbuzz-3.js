// range :: Int -> Int -> [Int]
const range = (min, max) =>
  Array.from({ length: max - min }, (_, i) => min + i)

const defaultRules = Object.freeze([
  [3, 'Fizz'],
  [5, 'Buzz'],
  [7, 'Baxx'],
])

// fizzBuzz :: Int -> [[Int, String]] -> String
const fizzBuzz = (max, rules = defaultRules) =>
  range(1, max + 1).map(n =>
    rules.reduce((words, [factor, word]) =>
      words + (n % factor ? '' : word), ''
    ) || n
  ).join('\n')

console.log(fizzBuzz(20))
