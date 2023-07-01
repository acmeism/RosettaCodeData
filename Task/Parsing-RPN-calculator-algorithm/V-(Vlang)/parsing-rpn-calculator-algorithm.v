import math

const (
    supported_operations = ['+', '-', '*', '/', '^']
    max_depth = 256
)

struct Stack {
mut:
	data  []f32 = [f32(0)].repeat(max_depth)
	depth int
}

fn (mut stack Stack) push(value f32) {
	if stack.depth >= max_depth {
		println('Stack Overflow!!')
		return
	}
	stack.data[stack.depth] = value
	stack.depth++
}

fn (mut stack Stack) pop() ?f32 {
	if stack.depth > 0 {
		stack.depth--
		result := stack.data[stack.depth]
		return result
	}
	return error('Stack Underflow!!')
}

fn (stack Stack) peek() ?f32 {
	if stack.depth > 0 {
		result := stack.data[0]
		return result
	}
	return error('Out of Bounds...')
}

fn (mut stack Stack) rpn(input string) ?f32 {
	println('Input: $input')
	tokens := input.split(' ')
	mut a := f32(0)
	mut b := f32(0)
	println('Token     Stack')
	for token in tokens {
		if token.str.is_digit() {
			stack.push(token.f32())
		} else if token in supported_operations {
			b = stack.pop() or { f32(0) }
			a = stack.pop() or { f32(0) }
			match token {
				'+' {
					stack.push(a + b)
				}
				'-' {
					stack.push(a - b)
				}
				'*' {
					stack.push(a * b)
				}
				'/' {
					stack.push(a / b)
				}
				'^' {
					stack.push(f32(math.pow(a, b)))
				}
				else {
					println('Oofffff')
				}
			}
		}
		print('${token:5s}     ')
		for i := 0; i < stack.depth; i++ {
			if i == stack.depth - 1 {
				println('${stack.data[i]:0.6f} |>')
			} else {
				print('${stack.data[i]:0.6f}, ')
			}
		}
	}
	return stack.peek()
}

fn main() {
	mut calc := Stack{}
	result := calc.rpn('3 4 2 * 1 5 - 2 3 ^ ^ / +') or { return }
	println('\nResult:   $result')
}
