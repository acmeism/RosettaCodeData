/** A single node in an AVL tree */
class AVLnode <T> {
    balance: number
    left: AVLnode<T>
    right: AVLnode<T>

    constructor(public key: T, public parent: AVLnode<T> = null) {
        this.balance = 0
        this.left = null
        this.right = null
    }
}

/** The balanced AVL tree */
class AVLtree <T> {
    // public members organized here
    constructor() {
        this.root = null
    }

    insert(key: T): boolean {
        if (this.root === null) {
            this.root = new AVLnode<T>(key)
        } else {
            let n: AVLnode<T> = this.root,
                parent: AVLnode<T> = null

            while (true) {
                if(n.key === key) {
                    return false
                }

                parent = n

                let goLeft: boolean = n.key > key
                n = goLeft ? n.left : n.right

                if (n === null) {
                    if (goLeft) {
                        parent.left = new AVLnode<T>(key, parent)
                    } else {
                        parent.right = new AVLnode<T>(key, parent)
                    }

                    this.rebalance(parent)
                    break
                }
            }
        }

        return true
    }

    deleteKey(delKey: T): void {
        if (this.root === null) {
            return
        }

        let n: AVLnode<T> = this.root,
            parent: AVLnode<T> = this.root,
            delNode: AVLnode<T> = null,
            child: AVLnode<T> = this.root

        while (child !== null) {
            parent = n
            n = child
            child = delKey >= n.key ? n.right : n.left
            if (delKey === n.key) {
                delNode = n
            }
        }

        if (delNode !== null) {
            delNode.key = n.key

            child = n.left !== null ? n.left : n.right

            if (this.root.key === delKey) {
                this.root = child
            } else {
                if (parent.left === n) {
                    parent.left = child
                } else {
                    parent.right = child
                }

                this.rebalance(parent)
            }
        }
    }

    treeBalanceString(n: AVLnode<T> = this.root): string {
        if (n !== null) {
            return `${this.treeBalanceString(n.left)} ${n.balance} ${this.treeBalanceString(n.right)}`
        }
        return ""
    }

    toString(n: AVLnode<T> = this.root): string {
        if (n !== null) {
            return `${this.toString(n.left)} ${n.key} ${this.toString(n.right)}`
        }
        return ""
    }


    // private members organized here
    private root: AVLnode<T>

    private rotateLeft(a: AVLnode<T>): AVLnode<T> {
        let b: AVLnode<T> = a.right
        b.parent = a.parent
        a.right = b.left

        if (a.right !== null) {
            a.right.parent = a
        }

        b.left = a
        a.parent = b

        if (b.parent !== null) {
            if (b.parent.right === a) {
                b.parent.right = b
            } else {
                b.parent.left = b
            }
        }

        this.setBalance(a)
        this.setBalance(b)

        return b
    }

    private rotateRight(a: AVLnode<T>): AVLnode<T> {
        let b: AVLnode<T> = a.left
        b.parent = a.parent
        a.left = b.right

        if (a.left !== null) {
            a.left.parent = a
        }

        b.right = a
        a.parent = b

        if (b.parent !== null) {
            if (b.parent.right === a) {
                b.parent.right = b
            } else {
                b.parent.left = b
            }
        }

        this.setBalance(a)
        this.setBalance(b)

        return b
    }

    private rotateLeftThenRight(n: AVLnode<T>): AVLnode<T> {
        n.left = this.rotateLeft(n.left)
        return this.rotateRight(n)
    }

    private rotateRightThenLeft(n: AVLnode<T>): AVLnode<T> {
        n.right = this.rotateRight(n.right)
        return this.rotateLeft(n)
    }

    private rebalance(n: AVLnode<T>): void {
        this.setBalance(n)

        if (n.balance === -2) {
            if(this.height(n.left.left) >= this.height(n.left.right)) {
                n = this.rotateRight(n)
            } else {
                n = this.rotateLeftThenRight(n)
            }
        } else if (n.balance === 2) {
            if(this.height(n.right.right) >= this.height(n.right.left)) {
                n = this.rotateLeft(n)
            } else {
                n = this.rotateRightThenLeft(n)
            }
        }

        if (n.parent !== null) {
            this.rebalance(n.parent)
        } else {
            this.root = n
        }
    }

    private height(n: AVLnode<T>): number {
        if (n === null) {
            return -1
        }
        return 1 + Math.max(this.height(n.left), this.height(n.right))
    }

    private setBalance(n: AVLnode<T>): void {
        n.balance = this.height(n.right) - this.height(n.left)
    }

    public showNodeBalance(n: AVLnode<T>): string {
        if (n !== null) {
            return `${this.showNodeBalance(n.left)} ${n.balance} ${this.showNodeBalance(n.right)}`
        }
        return ""
    }
}
