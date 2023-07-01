example = 'Tux 🐧 penguin';

// array expansion operator
[...example].reverse().join('') // 'niugnep 🐧 xuT'
// split regexp separator with Unicode mode
example.split(/(?:)/u).reverse().join('') // 'niugnep 🐧 xuT'

// do not use
example.split('').reverse().join(''); // 'niugnep \udc27\ud83d xuT'
