const fs = require('fs');

function main() {
    try {
        const percentages = parseUtilization(procStat());
        console.log(`${'idle'.padEnd(10)} ${(percentages[0] * 100).toFixed(2)}%`);
        console.log(`${'not-idle'.padEnd(10)} ${(percentages[1] * 100).toFixed(2)}%`);
    } catch (error) {
        console.error('Error:', error.message);
    }
}

function procStat() {
    const data = fs.readFileSync('/proc/stat', 'utf8');
    return data.split('\n')[0];
}

/**
 * @param {string} string - The proc/stat line to parse
 * @returns {number[]} Array containing idle and not-idle percentage values
 */
function parseUtilization(string) {
    string = string.substring(4).trimStart();
    let total = 0;
    let idle = 0;
    let notIdle;
    let index = 0;

    for (const value of string.split(' ')) {
        const num = parseInt(value);
        if (index === 3) {
            idle = num;
        }
        total += num;
        index++;
    }

    idle /= total;
    notIdle = 1 - idle;
    return [idle, notIdle];
}

// Run the main function
main();
