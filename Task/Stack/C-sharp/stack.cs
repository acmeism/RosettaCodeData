// Non-Generic Stack
System.Collections.Stack stack = new System.Collections.Stack();
stack.Push( obj );
bool isEmpty = stack.Count == 0;
object top = stack.Peek(); // Peek without Popping.
top = stack.Pop();

// Generic Stack
System.Collections.Generic.Stack<Foo> stack = new System.Collections.Generic.Stack<Foo>();
stack.Push(new Foo());
bool isEmpty = stack.Count == 0;
Foo top = stack.Peek(); // Peek without Popping.
top = stack.Pop();
