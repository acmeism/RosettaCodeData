module rosettacode;

import std::io;
import std::collections::deque;

struct Node<Type>
{
	Type value;
	Node* left, right;
}

fn void Node.free(&self)
{
	if (self == null) return;
	if (self.left) self.left.free();
	if (self.right) self.right.free();
	mem::free(self);
}

fn void Node.preorder(&self)
{
	io::printf("%d ", self.value);
	if (self.left) self.left.preorder();
	if (self.right) self.right.preorder();
}

fn void Node.inorder(&self)
{
	if (self.left) self.left.inorder();
	io::printf("%d ", self.value);
	if (self.right) self.right.inorder();
}

fn void Node.postorder(&self)
{
	if (self.left) self.left.postorder();
	if (self.right) self.right.postorder();
	io::printf("%d ", self.value);
}

fn void Node.levelorder(&self)
{
	Deque{Node*} q;
	defer q.free();
	q.tinit();

	q.push(self);

	while (!q.is_empty())
	{
		Node* n = q.pop_first()!!;
		io::printf("%d ", n.value);
		if (n.left) q.push(n.left);
		if (n.right) q.push(n.right);
	}
}

macro Node{Type}* tree(Type value, Node* left = null, Node* right = null) <Type>
{
	return mem::tnew(Node{Type}, { .value = value, .left = left, .right = right });
}

fn int main(String[] args)
{
	Node{int}* t = tree(1, tree(2, tree(4, tree(7)), tree(5)), tree(3, tree(6, tree(8), tree(9))));

	io::print("preorder: ");
	t.preorder();
	io::printn();

	io::print("inorder: ");
	t.inorder();
	io::printn();

	io::print("postorder: ");
	t.postorder();
	io::printn();

	io::print("levelorder: ");
	t.levelorder();
	io::printn();
	return 0;
}
