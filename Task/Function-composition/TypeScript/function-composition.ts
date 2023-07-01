function compose<T, U, V> (fn1: (input: T) => U, fn2: (input: U) => V){
    return function(value: T) {
        return fn2(fn1(value))
    }
}

function size (s: string): number { return s.length; }

function isEven(x: number): boolean { return x % 2 === 0; }

const evenSize = compose(size, isEven);

console.log(evenSize("ABCD")) // true
console.log(evenSize("ABC")) // false
