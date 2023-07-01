const (
    max_depth = 256
)

struct Stack {
mut:
    data  []f32 = []f32{len: max_depth}
    depth int
}

fn (mut s Stack) push(v f32) {
    if s.depth >= max_depth {
        return
    }
    println('Push: ${v:3.2f}')
    s.data[s.depth] = v
    s.depth++
}

fn (mut s Stack) pop() ?f32 {
    if s.depth > 0 {
        s.depth--
        result := s.data[s.depth]
        println('Pop: top of stack was ${result:3.2f}')
        return result
    }
    return error('Stack Underflow!!')
}

fn (s Stack) peek() ?f32 {
    if s.depth > 0 {
        result := s.data[s.depth - 1]
        println('Peek: top of stack is ${result:3.2f}')
        return result
    }
    return error('Out of Bounds...')
}

fn (s Stack) empty() bool {
    return s.depth == 0
}

fn main() {
    mut stack := Stack{}
    println('Stack is empty? ' + if stack.empty() { 'Yes' } else { 'No' })
    stack.push(5.0)
    stack.push(4.2)
    println('Stack is empty? ' + if stack.empty() { 'Yes' } else { 'No' })
    stack.peek() or { return }
    stack.pop() or { return }
    stack.pop() or { return }
}
