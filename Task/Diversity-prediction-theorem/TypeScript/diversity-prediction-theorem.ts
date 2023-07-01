function sum(array: Array<number>): number {
    return array.reduce((a, b) => a + b)
}

function square(x : number) :number {
    return x * x
}

function mean(array: Array<number>): number {
    return sum(array) / array.length
}

function averageSquareDiff(a: number, predictions: Array<number>): number {
    return mean(predictions.map(x => square(x - a)))
}

function diversityTheorem(truth: number, predictions: Array<number>): Object {
    const average: number = mean(predictions)
    return {
        "average-error": averageSquareDiff(truth, predictions),
        "crowd-error": square(truth - average),
        "diversity": averageSquareDiff(average, predictions)
    }
}

console.log(diversityTheorem(49, [48,47,51]))
console.log(diversityTheorem(49, [48,47,51,42]))
