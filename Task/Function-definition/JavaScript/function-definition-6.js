var multiply = (a, b) => a * b;
var multiply = (a, b) => { return a * b };

// Or, `var` being long deprecated, and currying convenient,
// (particularly in use with the higher-order Array methods)

const multiply = a =>
    b => a * b;
