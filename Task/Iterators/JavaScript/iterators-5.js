//@ts-check

/** @template T @implements {Iterable<T,void,void>} */
export class LinkedList {
  /** @type {LinkedListNode<T>?} */ root = null
  constructor(/** @type {T[]} */ values = []) {
    for (let i = values.length - 1; i >= 0; --i) {
      this.root = new LinkedListNode(values[i], this.root)
    }
  }
  [Symbol.iterator]() {
    return new LinkedListIterator(this.root)
  }
}

/** @template T @implements {Iterator<T,void,void>} */
class LinkedListIterator {
  node
  constructor(/** @type {LinkedListNode<T>?} */ node) {
    this.node = node
  }
  next() {
    if (this.node) {
      const result = this.node
      this.node = this.node.nextNode
      return result
    } else {
      const /** @type {true} */ done = true
      return { done, value: undefined }
    }
  }
}

/** @template T @implements {IteratorYieldResult<T>} */
class LinkedListNode {
  value
  nextNode
  constructor(/** @type {T} */ value, /** @type {LinkedListNode<T>?} */ nextNode = null) {
    this.value = value
    this.nextNode = nextNode
  }
}

/** @template T @returns {T|void} */
export function nth(/** @type {Iterable<T,void,void>} */ iterable, n = 1) {
  const iterator = iterable[Symbol.iterator]()
  while (n > 1) {
    if (iterator.next().done) return
    n--
  }
  return iterator.next().value
}

/** @template T @returns {T|void} */
export function nthLast(/** @type {Iterable<T,void,void>} */ iterable, n = 1) {
  const /** @type {T[]} */ values = []
  for (const value of iterable) {
    values.unshift(value)
    if (values.length > n) {
      values.pop()
    }
  }
  return values[n - 1]
}
