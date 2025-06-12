function chunk_array(arr, n) {
    const chunks = [];

    for (let i = 0; i < arr.length; i++) {
        const sliced = arr.slice(i, i + n);
        if (sliced.length == n) {
            chunks.push(sliced);
        }
    }

    return chunks;
}

function isColorful(num) {
    const numArr = num.toString().split('').map(item => parseInt(item));

    if (numArr.length == 1) {
        return true;
    }

    const count = {};

    for (const num of numArr) {
        const c = (count[num] || 0) + 1;

        if (c == 2) {
            return false;
        }

        count[num] = c;
    }

    const prods = [];

    for(let i = 2; i < numArr.length+1; i++) {
        const chunked = chunk_array(numArr, i);
        for (const chunk of chunked) {
            const prod = chunk.reduce((prev, val) => prev * val, 1);

            if (numArr.includes(prod) || prods.includes(prod)) {
                return false;
            }
            prods.push(prod);
        }
    }

    return true;
}


const colorful = [];

for(let i = 0; i < 100; i++) {
    if (isColorful(i)) {
        colorful.push(i);
    }
}

console.log(`Amount of colorful numbers lesser than 100 is ${colorful.length}`);
console.log(colorful);

let isStart = true;
let maxColorful = 0;
let totalCount = 0;

for (let i = 10; i < 1000000000; i *= 10) {
    const colorful = [];

    for(let j = isStart ? 0 : (i / 10); j < i; j++) {
        if (isColorful(j)) {
            colorful.push(j);
            maxColorful = Math.max(maxColorful, j);
        }
    }

    totalCount += colorful.length;
    console.log(`The count of colorful numbers between ${isStart ? 0 : (i / 10)} and ${i-1} is ${colorful.length}`);

    if (isStart) {
        isStart = false;
    }
}

console.log(`The largest possible colorful number is ${maxColorful}.`);
console.log(`The total number of colorful numbers is ${totalCount}.`);
