// Required Node.js modules
const fs = require('fs');
const path = require('path'); // Useful for joining paths if needed

// --- Constants ---
const WORD_SIZE = 4; // In bytes

// --- Enums (JavaScript Object Equivalents) ---

const Mnemonic = {
    NONE: { ordinal: 0, name: 'NONE' },
    FETCH: { ordinal: 1, name: 'FETCH' },
    STORE: { ordinal: 2, name: 'STORE' },
    PUSH: { ordinal: 3, name: 'PUSH' },
    ADD: { ordinal: 4, name: 'ADD' },
    SUB: { ordinal: 5, name: 'SUB' },
    MUL: { ordinal: 6, name: 'MUL' },
    DIV: { ordinal: 7, name: 'DIV' },
    MOD: { ordinal: 8, name: 'MOD' },
    LT: { ordinal: 9, name: 'LT' },
    GT: { ordinal: 10, name: 'GT' },
    LE: { ordinal: 11, name: 'LE' },
    GE: { ordinal: 12, name: 'GE' },
    EQ: { ordinal: 13, name: 'EQ' },
    NE: { ordinal: 14, name: 'NE' },
    AND: { ordinal: 15, name: 'AND' },
    OR: { ordinal: 16, name: 'OR' },
    NEG: { ordinal: 17, name: 'NEG' },
    NOT: { ordinal: 18, name: 'NOT' },
    JMP: { ordinal: 19, name: 'JMP' },
    JZ: { ordinal: 20, name: 'JZ' },
    PRTC: { ordinal: 21, name: 'PRTC' },
    PRTS: { ordinal: 22, name: 'PRTS' },
    PRTI: { ordinal: 23, name: 'PRTI' },
    HALT: { ordinal: 24, name: 'HALT' },
};

// Helper array to map ordinal back to Mnemonic object (for listCode)
const MnemonicByOrdinal = Object.values(Mnemonic).sort((a, b) => a.ordinal - b.ordinal);


const NodeType = {
    nd_None: { name: 'None', mnemonic: Mnemonic.NONE },
    nd_Ident: { name: 'Identifier', mnemonic: Mnemonic.NONE },
    nd_String: { name: 'String', mnemonic: Mnemonic.NONE },
    nd_Integer: { name: 'Integer', mnemonic: Mnemonic.NONE },
    nd_Sequence: { name: 'Sequence', mnemonic: Mnemonic.NONE },
    nd_If: { name: 'If', mnemonic: Mnemonic.NONE },
    nd_Prtc: { name: 'Prtc', mnemonic: Mnemonic.PRTC },
    nd_Prts: { name: 'Prts', mnemonic: Mnemonic.PRTS },
    nd_Prti: { name: 'Prti', mnemonic: Mnemonic.PRTI },
    nd_While: { name: 'While', mnemonic: Mnemonic.NONE },
    nd_Assign: { name: 'Assign', mnemonic: Mnemonic.NONE },
    nd_Negate: { name: 'Negate', mnemonic: Mnemonic.NEG },
    nd_Not: { name: 'Not', mnemonic: Mnemonic.NOT },
    nd_Mul: { name: 'Multiply', mnemonic: Mnemonic.MUL },
    nd_Div: { name: 'Divide', mnemonic: Mnemonic.DIV },
    nd_Mod: { name: 'Mod', mnemonic: Mnemonic.MOD },
    nd_Add: { name: 'Add', mnemonic: Mnemonic.ADD },
    nd_Sub: { name: 'Subtract', mnemonic: Mnemonic.SUB },
    nd_Lss: { name: 'Less', mnemonic: Mnemonic.LT },
    nd_Leq: { name: 'LessEqual', mnemonic: Mnemonic.LE },
    nd_Gtr: { name: 'Greater', mnemonic: Mnemonic.GT },
    nd_Geq: { name: 'GreaterEqual', mnemonic: Mnemonic.GE },
    nd_Eql: { name: 'Equal', mnemonic: Mnemonic.EQ },
    nd_Neq: { name: 'NotEqual', mnemonic: Mnemonic.NE },
    nd_And: { name: 'And', mnemonic: Mnemonic.AND },
    nd_Or: { name: 'Or', mnemonic: Mnemonic.OR },
};


// --- AST Node Class ---
class Node {
    constructor(nt = null, left = null, right = null, value = null) {
        this.nt = nt;
        this.left = left;
        this.right = right;
        this.value = value;
    }

    static makeNode(nodetype, left, right) {
        return new Node(nodetype, left, right, null);
    }

    static makeNode1(nodetype, left) {
        return new Node(nodetype, left, null, null);
    }

    static makeLeaf(nodetype, value) {
        return new Node(nodetype, null, null, value);
    }
}


// --- Code Generator State and Methods ---

let code = new Uint8Array(0); // Use Uint8Array for byte code
const strToNodes = new Map();
const stringPool = [];
const variables = [];
let stringCount = 0;
let varCount = 0;

const unaryOps = [
    NodeType.nd_Negate, NodeType.nd_Not
];
const operators = [
    NodeType.nd_Mul, NodeType.nd_Div, NodeType.nd_Mod, NodeType.nd_Add, NodeType.nd_Sub,
    NodeType.nd_Lss, NodeType.nd_Leq, NodeType.nd_Gtr, NodeType.nd_Geq,
    NodeType.nd_Eql, NodeType.nd_Neq, NodeType.nd_And, NodeType.nd_Or
];

// State for reading AST from lines
let inputLines = [];
let currentLineIndex = 0;


function appendToCode(b) {
    const newCode = new Uint8Array(code.length + 1);
    newCode.set(code); // Copy existing bytes
    newCode[code.length] = b & 0xff; // Add new byte (ensure it's 0-255)
    code = newCode;
}

function emitByte(m) {
    appendToCode(m.ordinal);
}

function emitWord(n) {
    // Ensure n is treated as a 32-bit integer (signed or unsigned depends on context)
    // Emit bytes in big-endian order
    appendToCode((n >> 24) & 0xff);
    appendToCode((n >> 16) & 0xff);
    appendToCode((n >> 8) & 0xff);
    appendToCode(n & 0xff);
}

function emitWordAt(pos, n) {
    if (pos + WORD_SIZE > code.length) {
        throw new Error(`Emit word out of bounds at position ${pos}`);
    }
     // Ensure n is treated as a 32-bit integer
    code[pos] = (n >> 24) & 0xff;
    code[pos + 1] = (n >> 16) & 0xff;
    code[pos + 2] = (n >> 8) & 0xff;
    code[pos + 3] = n & 0xff;
}

function getWord(pos) {
    if (pos + WORD_SIZE > code.length) {
        throw new Error(`Get word out of bounds at position ${pos}`);
    }
    // Read bytes in big-endian order and combine into a 32-bit integer
    // Need to treat bytes as unsigned (0-255) using & 0xff
    let result = 0;
    result |= (code[pos] & 0xff) << 24;
    result |= (code[pos + 1] & 0xff) << 16;
    result |= (code[pos + 2] & 0xff) << 8;
    result |= (code[pos + 3] & 0xff);

    // Handle sign bit if the result is expected to be signed
    // In JS, bitwise ops treat numbers as signed 32-bit.
    // The above combination *might* result in a negative number
    // if the most significant bit is set (for values >= 2^31).
    // If the VM expects unsigned, this is fine. If signed,
    // JS handles this conversion reasonably well after the bitwise ops.
    // Let's return the potentially signed result from the bitwise ops.
    return result;
}


function fetchVarOffset(name) {
    let n = variables.indexOf(name);
    if (n === -1) {
        variables.push(name);
        n = varCount++;
    }
    return n;
}

function fetchStringOffset(str) {
    let n = stringPool.indexOf(str);
    if (n === -1) {
        stringPool.push(str);
        n = stringCount++;
    }
    return n;
}

function hole() {
    const t = code.length;
    emitWord(0); // Emit a placeholder word (0)
    return t; // Return the position of the hole
}

function arrayContains(arr, item) {
    return arr.includes(item); // JavaScript Array.prototype.includes is equivalent
}

function codeGen(x) {
    let n, p1, p2;
    if (x === null) return;

    switch (x.nt) {
        case NodeType.nd_None:
            return;
        case NodeType.nd_Ident:
            emitByte(Mnemonic.FETCH);
            n = fetchVarOffset(x.value);
            emitWord(n);
            break;
        case NodeType.nd_Integer:
            emitByte(Mnemonic.PUSH);
            emitWord(parseInt(x.value, 10)); // Use radix 10
            break;
        case NodeType.nd_String:
            emitByte(Mnemonic.PUSH);
            n = fetchStringOffset(x.value);
            emitWord(n);
            break;
        case NodeType.nd_Assign:
            n = fetchVarOffset(x.left.value);
            codeGen(x.right);
            emitByte(Mnemonic.STORE);
            emitWord(n);
            break;
        case NodeType.nd_If:
            // p2 needs scope beyond the if block, initialize before switch case
            codeGen(x.left); // Condition
            emitByte(Mnemonic.JZ); // Jump if condition is zero (false)
            p1 = hole(); // Placeholder for jump address (to 'else' or end of 'then')

            codeGen(x.right.left); // 'then' block

            if (x.right.right !== null) { // Check if 'else' block exists
                emitByte(Mnemonic.JMP); // Jump over 'else' block after 'then'
                p2 = hole(); // Placeholder for jump address (to end of 'else')
            }

            // Patch the JZ instruction: jump relative from instruction *after* the word
            emitWordAt(p1, code.length - (p1 + WORD_SIZE));

            if (x.right.right !== null) {
                codeGen(x.right.right); // 'else' block
                // Patch the JMP instruction: jump relative from instruction *after* the word
                emitWordAt(p2, code.length - (p2 + WORD_SIZE));
            }
            break;
        case NodeType.nd_While:
            p1 = code.length; // Start of the loop condition
            codeGen(x.left); // Condition
            emitByte(Mnemonic.JZ); // Jump if condition is zero (false)
            p2 = hole(); // Placeholder for jump address (to end of loop)

            codeGen(x.right); // Loop body

            emitByte(Mnemonic.JMP); // Jump back to the start of the loop condition
            // Jump relative from instruction *after* the word
            emitWord(p1 - (code.length + WORD_SIZE));

            // Patch the JZ instruction: jump relative from instruction *after* the word
            emitWordAt(p2, code.length - (p2 + WORD_SIZE));
            break;
        case NodeType.nd_Sequence:
            codeGen(x.left);
            codeGen(x.right);
            break;
        case NodeType.nd_Prtc:
            codeGen(x.left);
            emitByte(Mnemonic.PRTC);
            break;
        case NodeType.nd_Prti:
            codeGen(x.left);
            emitByte(Mnemonic.PRTI);
            break;
        case NodeType.nd_Prts:
            codeGen(x.left);
            emitByte(Mnemonic.PRTS);
            break;
        default:
            if (arrayContains(operators, x.nt)) {
                codeGen(x.left);
                codeGen(x.right);
                emitByte(x.nt.mnemonic); // Use the mnemonic property
            } else if (arrayContains(unaryOps, x.nt)) {
                codeGen(x.left);
                emitByte(x.nt.mnemonic); // Use the mnemonic property
            } else {
                throw new Error(`Error in code generator! Found ${x.nt.name}, expecting operator.`);
            }
    }
}

function listCode() {
    let pc = 0;
    console.log(`Datasize: ${varCount} Strings: ${stringCount}`);
    for (const s of stringPool) {
        console.log(`"${s}"`); // Print strings, maybe quoted
    }

    console.log("\n--- Code ---");

    while (pc < code.length) {
        process.stdout.write(`${pc.toString().padStart(4, ' ')} `); // Format like printf %4d
        const opcodeValue = code[pc++];
        if (opcodeValue >= MnemonicByOrdinal.length) {
             throw new Error(`Unknown opcode value ${opcodeValue} @ ${pc - 1}`);
        }
        const op = MnemonicByOrdinal[opcodeValue];

        let x;
        switch (op) {
            case Mnemonic.FETCH:
                x = getWord(pc);
                process.stdout.write(`fetch [${x}]`);
                pc += WORD_SIZE;
                break;
            case Mnemonic.STORE:
                x = getWord(pc);
                process.stdout.write(`store [${x}]`);
                pc += WORD_SIZE;
                break;
            case Mnemonic.PUSH:
                x = getWord(pc);
                process.stdout.write(`push  ${x}`);
                pc += WORD_SIZE;
                break;
            case Mnemonic.ADD: case Mnemonic.SUB: case Mnemonic.MUL: case Mnemonic.DIV: case Mnemonic.MOD:
            case Mnemonic.LT: case Mnemonic.GT: case Mnemonic.LE: case Mnemonic.GE: case Mnemonic.EQ: case Mnemonic.NE:
            case Mnemonic.AND: case Mnemonic.OR: case Mnemonic.NEG: case Mnemonic.NOT:
            case Mnemonic.PRTC: case Mnemonic.PRTI: case Mnemonic.PRTS: case Mnemonic.HALT:
                process.stdout.write(op.name.toLowerCase());
                break;
            case Mnemonic.JMP:
                x = getWord(pc); // Read relative offset
                // Relative offset is calculated from the *instruction following the word* in the VM
                // pc points to the byte *after* the word now.
                process.stdout.write(`jmp     (${x}) ${pc + x}`);
                pc += WORD_SIZE;
                break;
            case Mnemonic.JZ:
                x = getWord(pc); // Read relative offset
                 // Relative offset is calculated from the *instruction following the word* in the VM
                 // pc points to the byte *after* the word now.
                process.stdout.write(`jz      (${x}) ${pc + x}`);
                pc += WORD_SIZE;
                break;
            default:
                 // Should not happen if MnemonicByOrdinal is correctly built
                throw new Error(`Unknown opcode ${op.name} (${opcodeValue}) @ ${pc - 1}`);
        }
        console.log(); // Newline after each instruction
    }
}


// Helper function to get the next line from the pre-loaded array
function getNextLine() {
    if (currentLineIndex >= inputLines.length) {
        return null; // End of input
    }
    return inputLines[currentLineIndex++];
}

function loadAst() {
    let command, value;
    let line = getNextLine();

    while (line !== null) {
        value = null;
        // Check line length before substring to avoid errors
        if (line.length > 15) {
            command = line.substring(0, 15).trim();
            value = line.substring(15).trim();
        } else {
            command = line.trim();
        }

        if (command === ";") {
            return null; // End of a sequence or node definition
        }

        const nodeType = strToNodes.get(command);
        if (!nodeType) {
            throw new Error(`Command not found: '${command}' on line ${currentLineIndex}`);
        }

        if (value !== null && value !== "") { // Check value is not just empty string
             // Note: The Java code checks value != null. If the AST format
             // allows "Identifier   ", value will be "" after trim.
             // Let's stick closer to Java's null check, assuming non-leaf
             // nodes won't have anything after column 15 except whitespace.
             // Re-evaluating Java: `value != null` is set based on `line.length > 16`.
             // Let's emulate that logic closely.

             // Java logic: value = line.substring(15).trim(); IF line.length > 16
             // Then `if (value != null)` returns leaf.
             // If line.length <= 16, command = line.trim(), value = null.
             // So leaf nodes MUST have something after col 15.
             // Let's adjust: if line.length > 15, value = line.substring(15).trim().
             // Then check if value is non-empty. This handles "Identifier   " as non-leaf.

             // Corrected logic:
             if (line.length > 15 && line.substring(15).trim() !== "") {
                value = line.substring(15).trim();
                return Node.makeLeaf(nodeType, value);
             }
             // If line.length <= 15 OR substring(15).trim() is empty,
             // it's not a leaf with a value in that part of the line.
             // Fall through to non-leaf handling.
        }


        // If it's not a leaf (or the leaf value part was empty/absent based on col 15)
        // Recursively load children
        const left = loadAst();
        const right = loadAst(); // Might be null for unary/sequence end

        // Some nodes like Prtc, Prti, Prts, Negate, Not only have a left child
        // Based on the Java code_gen, these are treated as makeNode1 implicitly
        // but load_ast always tries to read two children.
        // The AST format must represent unary nodes with a ";" after the single child.
        // Example: Prtc\n Integer 10\n ;\n ;
        // This recursive loadAst handles that structure.
        return Node.makeNode(nodeType, left, right);
    }

    // Should ideally not reach here if input is well-formed and ends with AST
    // But needed for compiler in Java, let's return null in JS too for safety.
    return null;
}


// --- Initialization ---
function initialize() {
    strToNodes.set(";", NodeType.nd_None); // Special case for AST parsing termination
    strToNodes.set("Sequence", NodeType.nd_Sequence);
    strToNodes.set("Identifier", NodeType.nd_Ident);
    strToNodes.set("String", NodeType.nd_String);
    strToNodes.set("Integer", NodeType.nd_Integer);
    strToNodes.set("If", NodeType.nd_If);
    strToNodes.set("While", NodeType.nd_While);
    strToNodes.set("Prtc", NodeType.nd_Prtc);
    strToNodes.set("Prts", NodeType.nd_Prts);
    strToNodes.set("Prti", NodeType.nd_Prti);
    strToNodes.set("Assign", NodeType.nd_Assign);
    strToNodes.set("Negate", NodeType.nd_Negate);
    strToNodes.set("Not", NodeType.nd_Not);
    strToNodes.set("Multiply", NodeType.nd_Mul);
    strToNodes.set("Divide", NodeType.nd_Div);
    strToNodes.set("Mod", NodeType.nd_Mod);
    strToNodes.set("Add", NodeType.nd_Add);
    strToNodes.set("Subtract", NodeType.nd_Sub);
    strToNodes.set("Less", NodeType.nd_Lss);
    strToNodes.set("LessEqual", NodeType.nd_Leq);
    strToNodes.set("Greater", NodeType.nd_Gtr);
    strToNodes.set("GreaterEqual", NodeType.nd_Geq);
    strToNodes.set("Equal", NodeType.nd_Eql);
    strToNodes.set("NotEqual", NodeType.nd_Neq);
    strToNodes.set("And", NodeType.nd_And);
    strToNodes.set("Or", NodeType.nd_Or);
}


// --- Main Execution ---
function main() {
    initialize();

    const args = process.argv.slice(2); // Get command line arguments excluding 'node' and script name

    if (args.length > 0) {
        const filename = args[0];
        try {
            // Read the entire file synchronously for simpler line-by-line processing
            const fileContent = fs.readFileSync(filename, 'utf8');
            inputLines = fileContent.split(/\r?\n/); // Split into lines, handling common line endings
            currentLineIndex = 0; // Reset line index for loadAst

            const ast = loadAst();

            if (ast) {
                 codeGen(ast);
                 emitByte(Mnemonic.HALT); // Emit HALT after generating code for the main AST
                 listCode();
            } else {
                 console.log("No valid AST loaded.");
            }


        } catch (e) {
            console.error(`Error: ${e.message}`);
            // console.error(e.stack); // Uncomment for detailed stack trace
        }
    } else {
        console.log("Usage: node code_generator.js <ast_file>");
    }
}

// Execute the main function
if (require.main === module) {
    main();
}
