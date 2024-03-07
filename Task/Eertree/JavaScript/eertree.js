class Node {
    constructor(len, suffix, id, level) {
        this.edges = new Map(); // edges <Character, Node>
        this.link = suffix; // Suffix link points to another node
        this.length = len; // Length of the palindrome represented by this node
        this.palindrome = "";
        this.parent = null;
    }
}

class Eertree {
    constructor() {
        this.imaginary = new Node(-1, null, this.count++, 1); // also called odd length root node
        this.empty = new Node(0, this.imaginary, this.count++, 2); // also called even length root node
        this.maxSuffixOfT = this.empty; // this is the current node we are on also the maximum Suffix of tree T
        this.s = ""; // String processed by the Eertree
    }


    /**
     * Add will only add at most 1 node to the tree.
     * We get the max suffix palindrome with the same character before it
     * so we can get cQc which will be the new palindrome, c otherwise
     * If the node is already in the tree then we return 0 and create no new nodes
     * @param {Character} c
     * @returns int 1 if it created a new node an 0 otherwise
     */
    add(c){
        /**
         * Traverse the suffix palindromes of T in the order of decreasing length
         * Keep traversing until we get to imaginary node or until T[len - k] = a
         * @param {Node} startNode
         * @param {Character} a
         * @returns {Node} u
         */
        const getMaxSuffixPalindrome = (startNode, a) =>{
            let u = startNode;
            let n = this.s.length;
            let k = u.length;
            while(u !== this.imaginary && this.s[n - k - 1] !== a){
                if(u === u.link){
                    throw new Error('Infinite Loop');
                }
                u = u.link;
                k = u.length;
            }
            return u;
        };


        let Q = getMaxSuffixPalindrome(this.maxSuffixOfT, c);
        let createNewNode = !(Q.edges.has(c));
        if(createNewNode){
            let P = new Node();
            P.length = Q.length + 2;
            // this is because Q is a palindrome and the suffix and prefix == c so cQc = P
            //P.length == 1 if Q is the imaginary node
            if(P.length === 1){
                P.link = this.empty;
                P.palindrome = c;
            }
            else{
                /**
                 * Now we need to find the node to suffix link to
                 * Continue traversing suffix palindromes of T starting with the suffix
                 * we found earlier 's link
                 */
                P.link = getMaxSuffixPalindrome(Q.link, c).edges.get(c);
                P.palindrome = c + Q.palindrome + c;
            }
            P.parent = Q;
            Q.edges.set(c, P);
        }

        this.maxSuffixOfT = Q.edges.get(c);
        this.s += c;

        return createNewNode === true ? 1 : 0;
    }

    traverse(){
        let subpalindromes = [];

        const dfs = (node) => {
            if(node !== this.imaginary && node !== this.empty){
                subpalindromes.push(node.palindrome);
            }

            for(let [_, childNode] of node.edges){
                dfs(childNode);
            }
        }

        dfs(this.imaginary);
        dfs(this.empty);
        return subpalindromes;
    }
}

var getSubpalindromes = function(s) {
    let eertree = new Eertree();
    for(let c of s){
        eertree.add(c);
    }
    return eertree.traverse();
}

console.log(getSubpalindromes('eertree'));
