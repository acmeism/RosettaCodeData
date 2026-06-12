/** @template T @implements {Iterable<T,void,void>} */
class SimpleLinkedList {
  value
  nextNode
  constructor(/** @type {T} */ value, /** @type {SimpleLinkedList<T>?} */ nextNode = null) {
    this.value = value
    this.nextNode = nextNode
  }
  /** @returns {Generator<T,void>} */
  *[Symbol.iterator]() {
    yield this.value
    if (this.nextNode) {
      yield* this.nextNode
    }
  }
}

// in the interpreter
> const list = new SimpleLinkedList(1, new SimpleLinkedList(2, new SimpleLinkedList(3)))
undefined
> list
SimpleLinkedList {
  value: 1,
  nextNode: SimpleLinkedList {
    value: 2,
    nextNode: SimpleLinkedList { value: 3, nextNode: null }
  }
}
> [...list]
[ 1, 2, 3 ]
