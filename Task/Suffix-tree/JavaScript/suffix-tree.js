class Node {
  sub = ''; // a substring of the input string
  children = []; // list of child nodes
}

class SuffixTree {
  nodes = [];

  constructor(str) {
    this.nodes.push(new Node());
    for (let i = 0; i < str.length; ++i) {
      this.addSuffix(str.slice(i));
    }
  }

  addSuffix(suf) {
    let n = 0;
    let i = 0;
    while (i < suf.length) {
      const b = suf.charAt(i);
      const children = this.nodes[n].children;
      let x2 = 0;
      let n2;
      while (true) {
        if (x2 === children.length) {
          // no matching child, remainder of suf becomes new node.
          n2 = this.nodes.length;
          const temp = new Node();
          temp.sub = suf.slice(i);
          this.nodes.push(temp);
          children.push(n2);
          return;
        }
        n2 = children[x2];
        if (this.nodes[n2].sub.charAt(0) === b) break;
        x2++;
      }
      // find prefix of remaining suffix in common with child
      const sub2 = this.nodes[n2].sub;
      let j = 0;
      while (j < sub2.length) {
        if (suf.charAt(i + j) !== sub2.charAt(j)) {
          // split n2
          const n3 = n2;
          // new node for the part in common
          n2 = this.nodes.length;
          const temp = new Node();
          temp.sub = sub2.slice(0, j);
          temp.children.push(n3);
          this.nodes.push(temp);
          this.nodes[n3].sub = sub2.slice(j);  // old node loses the part in common
          this.nodes[n].children[x2] = n2;
          break;  // continue down the tree
        }
        j++;
      }
      i += j;  // advance past part in common
      n = n2;  // continue down the tree
    }
  }

  toString() {
    if (this.nodes.length === 0) {
      return '<empty>';
    }
    return this.toString_f(0, '');
  }

  toString_f(n, pre) {
    const children = this.nodes[n].children;
    if (children.length === 0) {
      return '- ' + this.nodes[n].sub + '\n';
    }
    let s = '┐ ' + this.nodes[n].sub + '\n';
    for (let i = 0; i < children.length - 1; i++) {
      const c = children[i];
      s += pre + '├─';
      s += this.toString_f(c, pre + '│ ');
    }
    s += pre + '└─';
    s += this.toString_f(children[children.length - 1], pre + '  ');
    return s;
  }
}

const st = new SuffixTree('banana');
console.log(st.toString());
