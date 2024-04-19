(() => {
function toNumeric(value) {
    return value
        .replace(/IV/, 'I'.repeat(4))
        .replace(/V/g, 'I'.repeat(5))
        .replace(/IX/, 'I'.repeat(9))
        .replace(/XC/, 'I'.repeat(90))
        .replace(/XL/, 'I'.repeat(40))
        .replace(/X/g, 'I'.repeat(10))
        .replace(/L/, 'I'.repeat(50))
        .replace(/CD/, 'I'.repeat(400))
        .replace(/CM/, 'I'.repeat(900))
        .replace(/C/g, 'I'.repeat(100))
        .replace(/D/g, 'I'.repeat(500))
        .replace(/M/g, 'I'.repeat(1000))
        .length;
}

const numerics = ["MMXVI", "MCMXC", "MMVIII", "MM", "MDCLXVI"]
    .map(toNumeric);

console.log(numerics);
})();
