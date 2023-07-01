functor = {nand, and, or, nor, implies, iff, xor}
display = {nand: '⊼', and: '∧', or: '∨', nor: '⊽', implies: '⇒', iff: '⇔', xor: '⊻', not: '¬'}
values = Object.values(trit)

log = 'NOT\n';
for (let a of values) log += `${display.not}${a} = ${a}\n`

log += '\nNAND         AND          OR           NOR          IMPLIES       IFF           XOR'
for (let a of values) {
    for (let b of values) {
        log += "\n"
        for (let op in functor) log += `${a} ${display[op]} ${b} = ${functor[op](a, b)}    `
    }
}
console.log(log)
