const max_tail = 256

struct Queue<T> {
mut:
	data  []T
	tail int
	head  int
}

fn (mut queue Queue<T>) push(value T) {
	if queue.tail >= max_tail || queue.tail < queue.head {
		return
	}
	println('push: $value')
	queue.data << value
	queue.tail++
}

fn (mut queue Queue<T>) pop() !T {
	if queue.tail > 0 && queue.head < queue.tail {
		result := queue.data[queue.head]
		queue.head++
		println('Dequeue: top of Queue was $result')
		return result
	}
	return error('Queue Underflow!!')
}

fn (queue Queue<T>) peek() !T {
	if queue.tail > 0 && queue.head < queue.tail {
		result := queue.data[queue.head]
		println('Peek: top of Queue is $result')
		return result
	}
	return error('Out of Bounds...')
}

fn (queue Queue<T>) empty() bool {
	return queue.tail == 0
}

fn main() {
	mut queue := Queue<f64>{}
	println('Queue is empty? ' + if queue.empty() { 'Yes' } else { 'No' })
	queue.push(5.0)
	queue.push(4.2)
	println('Queue is empty? ' + if queue.empty() { 'Yes' } else { 'No' })
	queue.peek() or { return }
	queue.pop() or { return }
	queue.pop() or { return }
	queue.push(1.2)
}
