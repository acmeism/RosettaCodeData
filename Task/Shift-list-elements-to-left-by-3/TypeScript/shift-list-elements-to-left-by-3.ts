function leftShift(arr: number[], n: number): void {
    for (let i = 0; i < n; i++) {
        arr.push( arr.shift()! );
    }
}

var arr: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9];
leftShift(arr, 3);
console.log(arr);
