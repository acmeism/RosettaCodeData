import ceylon.collection {

	ArrayList
}

class Symbol(shared String text) {
	string => text;
}

abstract class Node() of Leaf | Branch {}
class Leaf(shared String|Integer|Float|Symbol data) extends Node() {
	string => data.string;
}
class Branch() extends Node() {
	shared ArrayList<Node> nodes = ArrayList<Node>();
	string => nodes.string;
}

shared void run() {
	
	alias Token => String|Character|Integer|Float|Symbol;
	
	{Token*} tokenize(String input) {
				
		class Mode {
			shared new neutral {}
			shared new symbol {}
			shared new quoted {}
			shared new integer {}
			shared new float {}
			shared new escape {}
		}
				
		value tokens = ArrayList<Token>();
		variable value mode = Mode.neutral;
		value currentToken = StringBuilder();

		void completeToken() {
			value string = currentToken.string;
			if(mode == Mode.symbol) {
				tokens.add(Symbol(string));
			}
			if(mode == Mode.quoted) {
				tokens.add(string);
			}
			if(mode == Mode.integer) {
				assert(exists int = parseInteger(string));
				tokens.add(int);
			}
			if(mode == Mode.float) {
				assert(exists float = parseFloat(string));
				tokens.add(float);
			}
			mode = Mode.neutral;
			currentToken.clear();
		}

		for(char in input) {
			switch(char)
			case('(' | ')') {
				if(mode != Mode.quoted) {
					completeToken();
					tokens.add(char);
				} else {
					currentToken.appendCharacter(char);
				}
			}
			case('\"') {
				if(mode == Mode.escape) {
					currentToken.appendCharacter(char);
					mode = Mode.quoted;
				} else if(mode != Mode.quoted) {
					mode = Mode.quoted;
				} else if(mode == Mode.quoted) {
					completeToken();
				}
			}
			case('\\') {
				if(mode == Mode.quoted) {
					mode = Mode.escape;
				} else {
					currentToken.appendCharacter(char);
				}
			}
			case(' ' | '\n' | '\r') {
				if(mode != Mode.quoted) {
					completeToken();
				} else {
					currentToken.append(" ");
				}
			}
			else {
				if(mode == Mode.neutral) {
					if(char.digit) {
						mode = Mode.integer;
					} else {
						mode = Mode.symbol;
					}
				}
				if(mode == Mode.integer && (char == '.' || char == ',')) {
					mode = Mode.float;
				}
				currentToken.appendCharacter(char);
			}
		}
		completeToken();
		return tokens;
	}
	
	Node readFromTokens(ArrayList<Token> tokens) {
		if(exists first = tokens.accept()) {
			if(first == '(') {
				value branch = Branch();
				while(!tokens.empty) {
					if(exists token = tokens.first) {
						if(token == ')') {
							tokens.accept();
							break;
						} else {
							branch.nodes.add(readFromTokens(tokens));
						}
					}
				}
				return branch;
			} else {
				if(is String|Integer|Float|Symbol first) {
					return Leaf(first);
				} else {
					throw Exception("unexpected token ``first``");
				}
			}
		} else {
			return Branch();
		}
	}
	
	void prettyPrint(Node node, Integer indentation = 0) {
		
		void paddedPrint(String s) => print(" ".repeat(indentation) + s);
		
		if(is Leaf node) {
			paddedPrint(node.string);
		} else {
			paddedPrint("(");
			for(n in node.nodes) {
				prettyPrint(n, indentation + 2);
			}
			paddedPrint(")");
		}
	}

	value tokens = tokenize("""((data "quoted data" 123 4.5)
                                (data (!@# (4.5) "(more" "data)")))""");
	value tree = readFromTokens(ArrayList {*tokens});
	prettyPrint(tree);
}
