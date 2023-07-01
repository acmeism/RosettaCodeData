const determinant = arr =>
    arr.length === 1 ? (
        arr[0][0]
    ) : arr[0].reduce(
        (sum, v, i) => sum + v * (-1) ** i * determinant(
            arr.slice(1)
            .map(x => x.filter((_, j) => i !== j))
        ), 0
    );

const permanent = arr =>
    arr.length === 1 ? (
        arr[0][0]
    ) : arr[0].reduce(
        (sum, v, i) => sum + v * permanent(
            arr.slice(1)
            .map(x => x.filter((_, j) => i !== j))
        ), 0
    );

const M = [
    [0, 1, 2, 3, 4],
    [5, 6, 7, 8, 9],
    [10, 11, 12, 13, 14],
    [15, 16, 17, 18, 19],
    [20, 21, 22, 23, 24]
];
console.log(determinant(M));
console.log(permanent(M));
