function sumCubes(limit: number): number[] {
    let sumList: number[] = [];
    let sum = 0;
    for (let n = 0; n < limit; n++) {
        sum += n ** 3;
        sumList.push(sum);
    }
    return sumList;
}

console.log(sumCubes(50));
