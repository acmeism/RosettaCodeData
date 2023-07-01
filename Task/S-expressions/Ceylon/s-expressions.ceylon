class Symbol(symbol) {
    shared String symbol;
    string => symbol;
}

abstract class Token()
        of  DataToken | leftParen | rightParen {}

abstract class DataToken(data)
        of StringToken | IntegerToken | FloatToken | SymbolToken
        extends Token() {

    shared String|Integer|Float|Symbol data;
    string => data.string;
}

class StringToken(String data) extends DataToken(data) {}
class IntegerToken(Integer data) extends DataToken(data) {}
class FloatToken(Float data) extends DataToken(data) {}
class SymbolToken(Symbol data) extends DataToken(data) {}

object leftParen extends Token() {
    string => "(";
}
object rightParen extends Token() {
    string => ")";
}

class Tokens(String input) satisfies {Token*} {
    shared actual Iterator<Token> iterator() => object satisfies Iterator<Token> {

        variable value index = 0;

        shared actual Token|Finished next() {

            while(exists nextChar = input[index], nextChar.whitespace) {
                index++;
            }

            if(index >= input.size) {
                return finished;
            }

            assert(exists char = input[index]);

            if(char == '(') {
                index++;
                return leftParen;
            }
            if(char == ')') {
                index++;
                return rightParen;
            }

            if(char == '"') {
                value builder = StringBuilder();
                while(exists nextChar = input[++index]) {
                    if(nextChar == '"') {
                        index++;
                        break;
                    }
                    if(nextChar == '\\') {
                        if(exists nextNextChar = input[++index]) {
                            switch(nextNextChar)
                            case('\\') {
                                builder.append("\\");
                            }
                            case('t') {
                                builder.append("\t");
                            }
                            case('n') {
                                builder.append("\n");
                            }
                            case('"') {
                                builder.append("\"");
                            }
                            else {
                                throw Exception("unknown escaped character");
                            }
                        } else {
                            throw Exception("unclosed string");
                        }
                    } else {
                        builder.appendCharacter(nextChar);
                    }
                }
                return StringToken(builder.string);
            }

            value builder = StringBuilder();
            while(exists nextChar = input[index], !nextChar.whitespace && nextChar != '(' && nextChar != ')') {
                builder.appendCharacter(nextChar);
                index++;
            }
            value string = builder.string;
            if(is Integer int = Integer.parse(string)) {
                return IntegerToken(int);
            } else if(is Float float = Float.parse(string)) {
                return FloatToken(float);
            } else {
                return SymbolToken(Symbol(string));
            }
        }
    };
}

abstract class Node() of Atom | Group {}

class Atom(data) extends Node() {
    shared String|Integer|Float|Symbol data;
    string => data.string;
}
class Group() extends Node() satisfies {Node*} {
    shared variable Node[] nodes = [];
    string => nodes.string;
    shared actual Iterator<Node> iterator() => nodes.iterator();

}

Node buildTree(Tokens tokens) {

    [Group, Integer] recursivelyBuild(Token[] tokens, variable Integer index = 0) {
        value result = Group();
        while(exists token = tokens[index]) {
            switch (token)
            case (leftParen) {
                value [newNode, newIndex] = recursivelyBuild(tokens, index + 1);
                index = newIndex;
                result.nodes = result.nodes.append([newNode]);
            }
            case (rightParen) {
                return [result, index];
            }
            else {
                result.nodes = result.nodes.append([Atom(token.data)]);
            }
            index++;
        }
        return [result, index];
    }

    value root = recursivelyBuild(tokens.sequence())[0];
    return root.first else Group();
}

void prettyPrint(Node node, Integer indentation = 0) {

    void paddedPrint(String s) => print(" ".repeat(indentation) + s);

    if(is Atom node) {
        paddedPrint(node.string);
    } else {
        paddedPrint("(");
        for(n in node.nodes) {
            prettyPrint(n, indentation + 2);
        }
        paddedPrint(")");
    }
}

shared void run() {
    value tokens = Tokens("""((data "quoted data" 123 4.5)
                               (data (!@# (4.5) "(more" "data)")))""");
    print(tokens);

    value tree = buildTree(tokens);
    prettyPrint(tree);
}
