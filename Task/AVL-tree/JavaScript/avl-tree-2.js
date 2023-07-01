function dumptree(t) {
  switch (t.depth) {
    case 0: return '';
    case 1: return t.val;
    default: return '('+dumptree(t.less)+','+t.val+','+dumptree(t.more)+')';
  }
}
function example() {
  let t= node(0);
  for (let j= 1; j<20; j++) {
    t= insert(node(j), t);
  }
  console.log(dumptree(t));
  t= remove(2, t);
  console.log(dumptree(t));
  console.log(dumptree(lookup(5, t)));
  console.log(dumptree(remove(5, t)));
}

example();
