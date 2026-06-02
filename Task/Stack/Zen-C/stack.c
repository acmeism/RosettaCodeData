import "std/stack.zc"

fn main() {
    let s = Stack<int>::new();
    println "Stack created.";
    let i = 2;
    s.push(i);
    println "'{i}' pushed onto the stack.";
    if s.length() > 0 {
         i = s.pop().unwrap();
         println "'{i}' popped from the stack.";
    }
    if s.is_empty() { println "Stack is now empty." }
}
