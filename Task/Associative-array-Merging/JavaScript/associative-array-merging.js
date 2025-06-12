const base = {
    "name": "Rocket Skates",
    "price": 12.75,
    "color": "yellow"
};

const update = {
    "price": 15.25,
    "color": "red",
    "year": 1974
};

// While ES6 destructuring may be cleaner, using Object.assign (provided in the original answer) instead is about 15-20% faster.
// source: https://jsbench.me/jom7uh9o1t/1

const final = Object.assign(base, update);
// Using ES6 destructuring method: const final = { ...base, ...update };

console.log(JSON.stringify(final, null, 4));
