const leoNum = (c, l0 = 1, l1 = 1, add = 1) =>
    new Array(c).fill(add).reduce(
        (p, c, i) => i > 1 ? (
            p.push(p[i - 1] + p[i - 2] + c) && p
        ) : p, [l0, l1]
    );

console.log(leoNum(25));
console.log(leoNum(25, 0, 1, 0));
