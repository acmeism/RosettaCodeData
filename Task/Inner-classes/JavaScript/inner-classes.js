class Outer {
  #outerValue; // # Marks the private attribute or method

  constructor(val) {
    this.#outerValue = val;
  }

  getValue() {
    return this.#outerValue;
  }

  static Inner = class {
    #innerValue;
    constructor(val) {
      this.#innerValue = val;
    }

    logInner() {
      console.log(this.#innerValue);
    }

    addOuter(outer) {
      return this.#innerValue + outer.getValue();
    }

  }
}

const obj = new Outer(5);
const inner = new Outer.Inner(3);
console.log(inner.addOuter(obj));
