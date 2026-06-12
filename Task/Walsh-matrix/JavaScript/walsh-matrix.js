function main() {
    const types = ["Natural", "Sequency"];
    const orders = [2, 4, 5];

    for (const type of types) {
        for (const order of orders) {
            const size = 1 << order;
            console.log(`Walsh matrix of order ${order}, ${type} order:`);
            let walsh = walshMatrix(size);
            if (type === "Sequency") {
                walsh.sort(rowComparator);
            }
            display(walsh);
        }
    }
}

function walshMatrix(size) {
    // Create matrix filled with zeros
    const walsh = Array.from({ length: size }, () => Array(size).fill(0));
    walsh[0][0] = 1;

    let k = 1;
    while (k < size) {
        for (let i = 0; i < k; i++) {
            for (let j = 0; j < k; j++) {
                walsh[i + k][j] = walsh[i][j];
                walsh[i][j + k] = walsh[i][j];
                walsh[i + k][j + k] = -walsh[i][j];
            }
        }
        k += k;
    }
    return walsh;
}

function signChangeCount(row) {
    let signChanges = 0;
    for (let i = 1; i < row.length; i++) {
        if (row[i - 1] === -row[i]) {
            signChanges += 1;
        }
    }
    return signChanges;
}

const rowComparator = (one, two) => signChangeCount(one) - signChangeCount(two);

function display(matrix) {
    for (const row of matrix) {
        let output = "";
        for (const element of row) {
            output += element.toString().padStart(3);
        }
        console.log(output);
    }
    console.log();
}

// Run the main function
main();
