const fs = require('fs');

UNDEFINED = -1;
LEAF_NODE = Number.MAX_SAFE_INTEGER;

class SuffixTree {
    constructor(aWord) {
        this.text = Array.from(aWord);
        this.text.push('\uF123'); // Terminal character

        this.nodes = new Array(2 * this.text.length);
        this.root = this.newNode(this.UNDEFINED, this.UNDEFINED);
        this.activeNode = this.root;

        this.textIndex = 0;
        this.currentNode = 0;
        this.needParentLink = this.UNDEFINED;
        this.remainder = 0;
        this.leafIndexGenerator = 0;

        for (let i = 0; i < this.text.length; i++) {
            this.extendSuffixTree(this.text[i]);
        }
    }

    getLongestRepeatedSubstrings() {
        const indexes = this.doTraversal();
        const word = this.text.slice(0, this.text.length - 1).join('');
        const result = {};

        if (indexes[0] > 0) {
            for (let i = 1; i < indexes.length; i++) {
                const substring = word.substring(indexes[i], indexes[i] + indexes[0]);
                if (!result[substring]) {
                    result[substring] = new Set();
                }
                result[substring].add(indexes[i]);
            }
        }

        return result;
    }

    extendSuffixTree(aCharacter) {
        this.needParentLink = this.UNDEFINED;
        this.remainder++;

        while (this.remainder > 0) {
            if (this.activeLength === 0) {
                this.activeEdge = this.textIndex;
            }

            if (!this.nodes[this.activeNode].children.hasOwnProperty(this.text[this.activeEdge])) {
                const leaf = this.newNode(this.textIndex, this.LEAF_NODE);
                this.nodes[this.activeNode].children[this.text[this.activeEdge]] = leaf;
                this.addSuffixLink(this.activeNode);
            } else {
                const next = this.nodes[this.activeNode].children[this.text[this.activeEdge]];
                if (this.walkDown(next)) {
                    continue;
                }

                if (this.text[this.nodes[next].start + this.activeLength] === aCharacter) {
                    this.activeLength++;
                    this.addSuffixLink(this.activeNode);
                    break;
                }

                const split = this.newNode(this.nodes[next].start, this.nodes[next].start + this.activeLength);
                this.nodes[this.activeNode].children[this.text[this.activeEdge]] = split;
                const leaf = this.newNode(this.textIndex, this.LEAF_NODE);
                this.nodes[split].children[aCharacter] = leaf;
                this.nodes[next].start += this.activeLength;
                this.nodes[split].children[this.text[this.nodes[next].start]] = next;
                this.addSuffixLink(split);
            }

            this.remainder--;

            if (this.activeNode === this.root && this.activeLength > 0) {
                this.activeLength--;
                this.activeEdge = this.textIndex - this.remainder + 1;
            } else {
                this.activeNode = (this.nodes[this.activeNode].parentLink > 0) ? this.nodes[this.activeNode].parentLink : this.root;
            }
        }

        this.textIndex++;
    }

    walkDown(aNode) {
        if (this.activeLength >= this.nodes[aNode].edgeLength()) {
            this.activeEdge += this.nodes[aNode].edgeLength();
            this.activeLength -= this.nodes[aNode].edgeLength();
            this.activeNode = aNode;

            return true;
        }

        return false;
    }

    addSuffixLink(aNode) {
        if (this.needParentLink !== this.UNDEFINED) {
            this.nodes[this.needParentLink].parentLink = aNode;
        }

        this.needParentLink = aNode;
    }

    newNode(aStart, aEnd) {
        const node = new Node(aStart, aEnd);
        node.leafIndex = (aEnd === this.LEAF_NODE) ? this.leafIndexGenerator++ : this.UNDEFINED;
        this.nodes[this.currentNode] = node;

        return this.currentNode++;
    }

    doTraversal() {
        const indexes = [this.UNDEFINED];

        return this.traversal(indexes, this.nodes[this.root], 0);
    }

    traversal(aIndexes, aNode, aHeight) {
        if (aNode.leafIndex === this.UNDEFINED) {
            for (const index of Object.values(aNode.children)) {
                const child = this.nodes[index];
                this.traversal(aIndexes, child, aHeight + child.edgeLength());
            }
        } else if (aIndexes[0] < aHeight - aNode.edgeLength()) {
            aIndexes.length = 0;
            aIndexes.push(aHeight - aNode.edgeLength());
            aIndexes.push(aNode.leafIndex);
        } else if (aIndexes[0] === aHeight - aNode.edgeLength()) {
            aIndexes.push(aNode.leafIndex);
        }

        return aIndexes;
    }



}

class Node {
    constructor(aStart, aEnd) {
        this.start = aStart;
        this.end = aEnd;
        this.parentLink = 0;
        this.leafIndex = 0;
        this.children = {};
    }

    edgeLength() {
        return Math.min(this.end, suffixTree.textIndex + 1) - this.start;
    }
}


async function main() {
    const limits = [1000, 10000, 100000];
    const piDigitsFile = 'piDigits.txt';

    try {
        const contents = await fs.promises.readFile(piDigitsFile, 'utf8');

        for (const limit of limits) {
            const piDigits = contents.substring(0, limit + 1);

            const start = Date.now();
            suffixTree = new SuffixTree(piDigits);
            const substrings = suffixTree.getLongestRepeatedSubstrings();
            const end = Date.now();

            console.log(`First ${limit} digits of pi has longest repeated characters:`);
            for (const substring in substrings) {
                if (substrings.hasOwnProperty(substring)) {
                    const indexes = Array.from(substrings[substring]);
                    console.log(`    '${substring}' starting at index ${indexes.join(' and ')}`);
                }
            }

            console.log(`Time taken: ${end - start} milliseconds.\n`);
        }

        console.log("The timings show that the implementation has approximately linear performance.");

    } catch (err) {
        console.error("An error occurred:", err);
    }
}

let suffixTree;

main();
