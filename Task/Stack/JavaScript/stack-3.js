function makeStack() {
  var stack = [];

  var popStack = function () {
    return stack.pop();
  };
  var pushStack = function () {
    return stack.push.apply(stack, arguments);
  };
  var isEmpty = function () {
    return stack.length === 0;
  };
  var peekStack = function () {
    return stack[stack.length-1];
  };

  return {
    pop: popStack,
    push: pushStack,
    isEmpty: isEmpty,
    peek: peekStack,
    top: peekStack
  };
}
