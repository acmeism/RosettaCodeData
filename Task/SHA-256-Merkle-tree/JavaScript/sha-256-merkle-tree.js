#!/usr/bin/env node

const fs = require('fs');
const crypto = require('crypto');

function computeMerkleRoot(filename = null, blockSize = 1024 * 1024) {
    let data;

    if (filename) {
        // Read file synchronously
        data = fs.readFileSync(filename);
    } else {
        // Read from stdin
        data = fs.readFileSync(0); // 0 is stdin file descriptor
    }

    const stack = [];
    let offset = 0;

    // Process blocks
    while (offset < data.length) {
        const block = data.slice(offset, offset + blockSize);

        // Create a node: [tree-level, hash]
        const hash = crypto.createHash('sha256').update(block).digest();
        const node = [0, hash];
        stack.push(node);

        // Concatenate adjacent pairs at the same level
        while (stack.length >= 2 && stack[stack.length - 2][0] === stack[stack.length - 1][0]) {
            const a = stack[stack.length - 2];
            const b = stack[stack.length - 1];
            const level = a[0];

            // Combine hashes
            const combinedHash = crypto.createHash('sha256')
                .update(Buffer.concat([a[1], b[1]]))
                .digest();

            // Replace last two elements with combined node
            stack.splice(-2, 2, [level + 1, combinedHash]);
        }

        offset += blockSize;
    }

    // Combine remaining nodes even across different levels
    while (stack.length > 1) {
        const a = stack[stack.length - 2];
        const b = stack[stack.length - 1];
        const al = a[0];
        const bl = b[0];

        const combinedHash = crypto.createHash('sha256')
            .update(Buffer.concat([a[1], b[1]]))
            .digest();

        // Replace last two elements with combined node
        stack.splice(-2, 2, [Math.max(al, bl) + 1, combinedHash]);
    }

    return stack[0][1].toString('hex');
}

// Command line interface
function main() {
    const args = process.argv.slice(2);
    let filename = null;
    let blockSize = 1024 * 1024; // Default 1MB

    // Simple argument parsing
    for (let i = 0; i < args.length; i++) {
        if (args[i] === '--block-size' && i + 1 < args.length) {
            blockSize = parseInt(args[i + 1]);
            i++; // Skip next argument
        } else if (!args[i].startsWith('--')) {
            filename = args[i];
        }
    }

    try {
        const result = computeMerkleRoot(filename, blockSize);
        console.log(result);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

// Run if this script is executed directly
if (require.main === module) {
    main();
}

module.exports = { computeMerkleRoot };
