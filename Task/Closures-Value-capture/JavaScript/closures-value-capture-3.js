"use strict";
let funcs = [];
for (let i = 0; i < 10; ++i) {
    funcs.push((i => () => i*i)(i));
}
console.log(funcs[3]());
