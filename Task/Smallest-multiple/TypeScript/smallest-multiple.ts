import { lcm } from 'mathjs';

function range(size:number, startAt:number = 0):ReadonlyArray<number> {
    return [...Array(size).keys()].map(i => i + startAt);
}

console.log(range(20, 1).reduce((a, b) => lcm(a, b)));
