function tree(less, val, more) {
  return {
    depth: 1+Math.max(less.depth, more.depth),
    less: less,
    val: val,
    more: more,
  };
}

function node(val) {
  return tree({depth: 0}, val, {depth: 0});
}

function insert(x,y) {
  if (0 == y.depth) return x;
  if (0 == x.depth) return y;
  if (1 == x.depth && 1 == y.depth) {
    switch (Math.sign(y.val)-x.val) {
      case -1: return tree(y, x.val, {depth: 0});
      case 0: return y;
      case 1: return tree(x, y.val, {depth: 0});
    }
  }
  switch (Math.sign(y.val-x.val)) {
    case -1: return balance(insert(x.less, y), x.val, x.more);
    case 0: return balance(insert(x.less, y.less), x.val, insert(x.more, y.more));
    case 1: return balance(x.less. x.val, insert(x.more, y));
  }
}

function balance(less,val,more) {
  if (2 > Math.abs(less.depth-more.depth))
    return tree(less,val,more);
  if (more.depth > less.depth) {
    if (more.more.depth >= more.less.depth) {
      // 'more' was heavy
      return moreHeavy(less, val, more);
    } else {
      return moreHeavy(less,val,lessHeavy(more.less, more.val, more.more));
    }
  } else {
    if(less.less.depth >= less.more.depth) {
      return lessHeavy(less, val, more);
    } else {
      return lessHeavy(moreHeavy(less.less, less.val, less.more), val, more);
    }
  }
}

function moreHeavy(less,val,more) {
  return tree(tree(less,val,more.less), more.val, more.more)
}

function lessHeavy(less,val,more) {
  return tree(less.less, less.val, tree(less.more, val, more));
}

function remove(val, y) {
  switch (y.depth) {
    case 0: return y;
    case 1:
      if (val == y.val) {
        return y.less;
      } else {
        return y;
      }
    default:
      switch (Math.sign(y.val - val)) {
        case -1: return balance(y.less, y.val, remove(val, y.more));
        case  0: return insert(y.less, y.more);
        case  1: return balance(remove(val, y.less), y.val, y.more)
      }
  }
}

function lookup(val, y) {
  switch (y.depth) {
    case 0: return y;
    case 1: if (val == y.val) {
      return y;
    } else {
      return {depth: 0};
    }
    default:
      switch (Math.sign(y.val-val)) {
        case -1: return lookup(val, y.more);
        case  0: return y;
        case  1: return lookup(val, y.less);
      }
  }
}
