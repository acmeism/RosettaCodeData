const Associativity = {
    /** a / b / c = (a / b) / c */
    left: 0,
    /** a ^ b ^ c = a ^ (b ^ c) */
    right: 1,
    /** a + b + c = (a + b) + c = a + (b + c) */
    both: 2,
};
const operators = {
    '+': { precedence: 2, associativity: Associativity.both },
    '-': { precedence: 2, associativity: Associativity.left },
    '*': { precedence: 3, associativity: Associativity.both },
    '/': { precedence: 3, associativity: Associativity.left },
    '^': { precedence: 4, associativity: Associativity.right },
};
class NumberNode {
    constructor(text) { this.text = text; }
    toString() { return this.text; }
}
class InfixNode {
    constructor(fnname, operands) {
        this.fnname = fnname;
        this.operands = operands;
    }
    toString(parentPrecedence = 0) {
        const op = operators[this.fnname];
        const leftAdd = op.associativity === Associativity.right ? 0.01 : 0;
        const rightAdd = op.associativity === Associativity.left ? 0.01 : 0;
        if (this.operands.length !== 2) throw Error("invalid operand count");
        const result = this.operands[0].toString(op.precedence + leftAdd)
            +` ${this.fnname} ${this.operands[1].toString(op.precedence + rightAdd)}`;
        if (parentPrecedence > op.precedence) return `( ${result} )`;
        else return result;
    }
}
function rpnToTree(tokens) {
    const stack = [];
    console.log(`input = ${tokens}`);
    for (const token of tokens.split(" ")) {
        if (token in operators) {
            const op = operators[token], arity = 2; // all of these operators take 2 arguments
            if (stack.length < arity) throw Error("stack error");
            stack.push(new InfixNode(token, stack.splice(stack.length - arity)));
        }
        else stack.push(new NumberNode(token));
        console.log(`read ${token}, stack = [${stack.join(", ")}]`);
    }
    if (stack.length !== 1) throw Error("stack error " + stack);
    return stack[0];
}
const tests = [
    ["3 4 2 * 1 5 - 2 3 ^ ^ / +", "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"],
    ["1 2 + 3 4 + ^ 5 6 + ^", "( ( 1 + 2 ) ^ ( 3 + 4 ) ) ^ ( 5 + 6 )"],
    ["1 2 3 + +", "1 + 2 + 3"] // test associativity (1+(2+3)) == (1+2+3)
];
for (const [inp, oup] of tests) {
    const realOup = rpnToTree(inp).toString();
    console.log(realOup === oup ? "Correct!" : "Incorrect!");
}
