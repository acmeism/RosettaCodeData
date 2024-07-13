trit = [false, undefined, true]
functor = {nand, and, or, nor, implies, iff, xor}
display = {nand: '⊼', and: '∧', or: '∨', nor: '⊽', implies: '→', iff: '↔', xor: '⊻', not: '¬', false: 'F', undefined: '?', true: 'T'}

log = 'NOT\n';
for (let a of trit) log += `${display.not}${display[a]} = ${display[not(a)]}\n`

log += '\nNAND         AND          OR           NOR          IMPLIES      IFF           XOR'
for (let a of trit) {
    for (let b of trit) {
        log += "\n"
        for (let op in functor) log += `${display[a]} ${display[op]} ${display[b]} = ${display[functor[op](a, b)]}    `
    }
}
console.log(log)
