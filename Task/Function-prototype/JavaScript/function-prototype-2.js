// A prototype declaration for a function that does not require arguments
class List {
  push() {
    return [].push.apply(this, arguments);
  }
  pop() {
    return [].pop.call(this);
  }
}

var l = new List();
l.push(5);
l.length; // 1
l[0]; 5
l.pop(); // 5
l.length; // 0



// A prototype declaration for a function that utilizes varargs
class List {
  constructor(...args) {
    this.push(...args);
  }
  push() {
    return [].push.apply(this, arguments);
  }
  pop() {
    return [].pop.call(this);
  }
}

var l = new List(5, 10, 15);
l.length; // 3
l[0]; 5
l.pop(); // 15
l.length; // 2
