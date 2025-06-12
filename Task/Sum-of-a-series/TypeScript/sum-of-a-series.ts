function s(n:number): number {
    return [...Array(n).keys()].map(k => 1 / (1+k)**2).reduce((a, b) => a + b);
}

console.log( s(1000) )
