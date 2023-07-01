class node{
	constructor(freq, char, left, right){
		this.left = left;
		this.right = right;
		this.freq = freq;
		this.c = char;
	}
};

nodes = [];
code = {};

function new_node(left, right){
	return new node(left.freq + right.freq, -1, left, right);;
};

function qinsert(node){
	nodes.push(node);
	nodes.sort(compareFunction);
};

function qremove(){
	return nodes.pop();
};

function compareFunction(a, b){
	return b.freq - a.freq;
};

function build_code(node, codeString, length){
	if (node.c != -1){
		code[node.c] = codeString;
		return;
	};
	/* Left Branch */
	leftCodeString = codeString + "0";
	build_code(node.left, leftCodeString, length + 1);
	/* Right Branch */
	rightCodeString = codeString + "1";
	build_code(node.right, rightCodeString, length + 1);
};

function init(string){
	var i;
	var freq = [];
	var codeString = "";
	
	for (var i = 0; i < string.length; i++){
		if (isNaN(freq[string.charCodeAt(i)])){
			freq[string.charCodeAt(i)] = 1;
		} else {
			freq[string.charCodeAt(i)] ++;
		};
	};
	
	for (var i = 0; i < freq.length; i++){
		if (freq[i] > 0){
			qinsert(new node(freq[i], i, null, null));
		};
	};
	
	while (nodes.length > 1){
		qinsert(new_node(qremove(), qremove()));
	};
	
	build_code(nodes[0], codeString, 0);
};

function encode(string){
	output = "";
	
	for (var i = 0; i < string.length; i ++){
		output += code[string.charCodeAt(i)];
	};
	
	return output;
};

function decode(input){
	output = "";
	node = nodes[0];
	
	for (var i = 0; i < input.length; i++){
		if (input[i] == "0"){
			node = node.left;
		} else {
			node = node.right;
		};
		
		if (node.c != -1){
			output += String.fromCharCode(node.c);
			node = nodes[0];
		};
	};
	
	return output
};


string = "this is an example of huffman encoding";
console.log("initial string: " + string);
init(string);
for (var i = 0; i < Object.keys(code).length; i++){
	if (isNaN(code[Object.keys(code)[i]])){
	} else {
		console.log("'" + String.fromCharCode(Object.keys(code)[i]) + "'" + ": " + code[Object.keys(code)[i]]);
	};
};

huffman = encode(string);
console.log("encoded: " + huffman + "\n");
output = decode(huffman);
console.log("decoded: " + output);
