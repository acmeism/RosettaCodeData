class VSegment {
  constructor() {
    this.next = null;
    this.elements = [];
  }
}

class VList {
  constructor() {
    this.base = new VSegment();
    this.base.elements = [];
    this.offset = 0;
  }

  // Add an element to the beginning of this VList
  cons(element) {
    if (this.base.elements.length === 0) {
      this.base.elements.push(element);
      return this;
    }

    if (this.offset === 0) {
      this.offset = this.base.elements.length * 2 - 1;
      const segment = new VSegment();
      segment.next = this.base;
      segment.elements = new Array(this.offset).fill(null);
      segment.elements.push(element);
      this.base = segment;
      return this;
    }

    this.offset -= 1;
    this.base.elements[this.offset] = element;
    return this;
  }

  // Return a new VList beginning at the second element of this VList
  cdr() {
    if (this.base.elements.length === 0) {
      throw new Error("cdr invoked on an empty VList");
    }

    this.offset += 1;
    if (this.offset < this.base.elements.length) {
      return this;
    }

    this.offset = 0;
    this.base = this.base.next;
    return this;
  }

  // Return the element located at the given index
  get(key) {
    if (key >= 0) {
      let index = key + this.offset;
      let segment = this.base;
      while (segment !== null) {
        if (index < segment.elements.length) {
          return segment.elements[index];
        }

        index -= segment.elements.length;
        segment = segment.next;
      }
    }

    throw new Error(`Index out of range: ${key}`);
  }

  // Return the size of this VList
  size() {
    return this.base.elements.length === 0
      ? 0
      : this.base.elements.length * 2 - this.offset - 1;
  }

  toString() {
    if (this.base.elements.length === 0) {
      return "[]";
    }

    let result = "[" + this.base.elements[this.offset];
    let segment = this.base;
    let elementsSublist = this.base.elements.slice(this.offset + 1);

    while (true) {
      for (const element of elementsSublist) {
        result += " " + element;
      }
      segment = segment.next;
      if (segment === null) {
        break;
      }
      elementsSublist = segment.elements;
    }
    result += "]";
    return result;
  }

  showStructure() {
    console.log("Offset: " + this.offset);
    let segment = this.base;
    while (segment !== null) {
      console.log(segment.elements);
      segment = segment.next;
    }
    console.log();
  }
}

// Main demonstration
function main() {
  let vList = new VList();
  console.log("Before adding any elements, the VList is empty: " + vList);
  vList.showStructure();

  for (let i = 6; i >= 1; i--) {
    vList = vList.cons(i);
  }
  console.log("Demonstrating cons method, 6 elements added: " + vList);
  vList.showStructure();

  vList = vList.cdr();
  console.log("Demonstrating cdr method, 1 element removed: " + vList);
  vList.showStructure();

  console.log("Demonstrating size property, size = " + vList.size() + "\n");
  console.log("Demonstrating element access, v[3] = " + vList.get(3) + "\n");

  vList = vList.cdr().cdr();
  console.log("Demonstrating cdr method again, 2 more elements removed: " + vList);
  vList.showStructure();
}

// Run the demonstration
main();
