function divisors(n: number): number[] {
    const divs = [1, n];
    const sqr = Math.sqrt(n);
    for (let d = 2; d <= sqr; d++) {
        if (n % d == 0) {
            divs.push(d);
            if (d != sqr) divs.push(n / d);
        }
    }  // We don't really need to sort them for this task but it's nice to make
    return divs.toSorted(function(a, b) {return a - b});  // functions reusable
}

let count = 0;
let val = 0;
let composites = 0;
const arithList: number[] =[];
const printValues = [1000, 10000, 100000, 1000000];
while (count < 10**6) {
    val += 1;
    const divList = divisors(val);
    const average = divList.reduce((a, b) => a + b) / divList.length;
    if (Number.isInteger(average)) {
        count += 1;
        if (divList.length > 2) composites++;
        if (count <= 100) arithList.push(val);
        if (count == 100) console.log(arithList);
        if (printValues.includes(count)) {
            console.log("The " + count + "th arithmetic number is " + val);
            console.log(composites + " of the first " + count + " are composite\n");
        }
    }
}
