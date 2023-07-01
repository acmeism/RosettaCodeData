import java.util.Scanner;
import java.io.File;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

class Interpreter {
	static Map<String, Integer> globals = new HashMap<>();
	static Scanner s;
	static List<Node> list = new ArrayList<>();
	static Map<String, NodeType> str_to_nodes = new HashMap<>();

	static class Node {
		public NodeType nt;
		public Node left, right;
		public String value;
		
		Node() {
			this.nt = null;
			this.left = null;
			this.right = null;
			this.value = null;
		}
		Node(NodeType node_type, Node left, Node right, String value) {
			this.nt = node_type;
			this.left = left;
			this.right = right;
			this.value = value;
		}
		public static Node make_node(NodeType nodetype, Node left, Node right) {
			return new Node(nodetype, left, right, "");
		}
		public static Node make_node(NodeType nodetype, Node left) {
			return new Node(nodetype, left, null, "");
		}
		public static Node make_leaf(NodeType nodetype, String value) {
			return new Node(nodetype, null, null, value);
		}
	}
	static enum NodeType {
		nd_None(";"), nd_Ident("Identifier"), nd_String("String"), nd_Integer("Integer"),
		nd_Sequence("Sequence"), nd_If("If"),
		nd_Prtc("Prtc"), nd_Prts("Prts"), nd_Prti("Prti"), nd_While("While"),
		nd_Assign("Assign"), nd_Negate("Negate"), nd_Not("Not"), nd_Mul("Multiply"), nd_Div("Divide"),
		nd_Mod("Mod"), nd_Add("Add"),
		nd_Sub("Subtract"), nd_Lss("Less"), nd_Leq("LessEqual"),
		nd_Gtr("Greater"), nd_Geq("GreaterEqual"), nd_Eql("Equal"), nd_Neq("NotEqual"), nd_And("And"), nd_Or("Or");
		
		private final String name;
		
		NodeType(String name) {	this.name = name; }
		
		@Override
		public String toString() { return this.name; }
	}
	static String str(String s) {
		String result = "";
		int i = 0;
		s = s.replace("\"", "");
		while (i < s.length()) {
			if (s.charAt(i) == '\\' && i + 1 < s.length()) {
				if (s.charAt(i + 1) == 'n') {
					result += '\n';
					i += 2;
				} else if (s.charAt(i) == '\\') {
					result += '\\';
					i += 2;
				}
			} else {
				result += s.charAt(i);
				i++;
			}
		}
		return result;
	}
	static boolean itob(int i) {
		return i != 0;
	}
	static int btoi(boolean b) {
		return b ? 1 : 0;
	}
	static int fetch_var(String name) {
		int result;
		if (globals.containsKey(name)) {
			result = globals.get(name);
		} else {
			globals.put(name, 0);
			result = 0;
		}
		return result;		
	}
	static Integer interpret(Node n) throws Exception {
		if (n == null) {
			return 0;
		}
		switch (n.nt) {
			case nd_Integer:
				return Integer.parseInt(n.value);
			case nd_Ident:
				return fetch_var(n.value);
			case nd_String:
				return 1;//n.value;
			case nd_Assign:
				globals.put(n.left.value, interpret(n.right));
				return 0;
			case nd_Add:
				return interpret(n.left) + interpret(n.right);
			case nd_Sub:
				return interpret(n.left) - interpret(n.right);
			case nd_Mul:
				return interpret(n.left) * interpret(n.right);
			case nd_Div:
				return interpret(n.left) / interpret(n.right);
			case nd_Mod:
				return interpret(n.left) % interpret(n.right);
			case nd_Lss:
				return btoi(interpret(n.left) < interpret(n.right));
			case nd_Leq:
				return btoi(interpret(n.left) <= interpret(n.right));
			case nd_Gtr:
				return btoi(interpret(n.left) > interpret(n.right));
			case nd_Geq:
				return btoi(interpret(n.left) >= interpret(n.right));
			case nd_Eql:
				return btoi(interpret(n.left) == interpret(n.right));
			case nd_Neq:
				return btoi(interpret(n.left) != interpret(n.right));
			case nd_And:
				return btoi(itob(interpret(n.left)) && itob(interpret(n.right)));
			case nd_Or:
				return btoi(itob(interpret(n.left)) || itob(interpret(n.right)));
			case nd_Not:
				if (interpret(n.left) == 0) {
					return 1;
				} else {
					return 0;
				}
			case nd_Negate:
				return -interpret(n.left);
			case nd_If:
				if (interpret(n.left) != 0) {
					interpret(n.right.left);
				} else {
					interpret(n.right.right);
				}
				return 0;
			case nd_While:
				while (interpret(n.left) != 0) {
					interpret(n.right);
				}
				return 0;
			case nd_Prtc:
				System.out.printf("%c", interpret(n.left));
				return 0;
			case nd_Prti:
				System.out.printf("%d", interpret(n.left));
				return 0;
			case nd_Prts:
				System.out.print(str(n.left.value));//interpret(n.left));
				return 0;
			case nd_Sequence:
				interpret(n.left);
				interpret(n.right);
				return 0;
			default:
				throw new Exception("Error: '" + n.nt + "' found, expecting operator");
		}
	}
	static Node load_ast() throws Exception {
		String command, value;
		String line;
		Node left, right;
		
		while (s.hasNext()) {
			line = s.nextLine();
			value = null;
			if (line.length() > 16) {
				command = line.substring(0, 15).trim();
				value = line.substring(15).trim();
			} else {
				command = line.trim();
			}
			if (command.equals(";")) {
				return null;
			}
			if (!str_to_nodes.containsKey(command)) {
				throw new Exception("Command not found: '" + command + "'");
			}
			if (value != null) {
				return Node.make_leaf(str_to_nodes.get(command), value);
			}
			left = load_ast(); right = load_ast();
			return Node.make_node(str_to_nodes.get(command), left, right);
		}
		return null; // for the compiler, not needed
	}
	public static void main(String[] args) {
		Node n;

		str_to_nodes.put(";", NodeType.nd_None);
		str_to_nodes.put("Sequence", NodeType.nd_Sequence);
		str_to_nodes.put("Identifier", NodeType.nd_Ident);
		str_to_nodes.put("String", NodeType.nd_String);
		str_to_nodes.put("Integer", NodeType.nd_Integer);
		str_to_nodes.put("If", NodeType.nd_If);
		str_to_nodes.put("While", NodeType.nd_While);
		str_to_nodes.put("Prtc", NodeType.nd_Prtc);
		str_to_nodes.put("Prts", NodeType.nd_Prts);
		str_to_nodes.put("Prti", NodeType.nd_Prti);
		str_to_nodes.put("Assign", NodeType.nd_Assign);
		str_to_nodes.put("Negate", NodeType.nd_Negate);
		str_to_nodes.put("Not", NodeType.nd_Not);
		str_to_nodes.put("Multiply", NodeType.nd_Mul);
		str_to_nodes.put("Divide", NodeType.nd_Div);
		str_to_nodes.put("Mod", NodeType.nd_Mod);
		str_to_nodes.put("Add", NodeType.nd_Add);
		str_to_nodes.put("Subtract", NodeType.nd_Sub);
		str_to_nodes.put("Less", NodeType.nd_Lss);
		str_to_nodes.put("LessEqual", NodeType.nd_Leq);
		str_to_nodes.put("Greater", NodeType.nd_Gtr);
		str_to_nodes.put("GreaterEqual", NodeType.nd_Geq);
		str_to_nodes.put("Equal", NodeType.nd_Eql);
		str_to_nodes.put("NotEqual", NodeType.nd_Neq);
		str_to_nodes.put("And", NodeType.nd_And);
		str_to_nodes.put("Or", NodeType.nd_Or);
		
		if (args.length > 0) {
			try {
				s = new Scanner(new File(args[0]));
				n = load_ast();
				interpret(n);
			} catch (Exception e) {
				System.out.println("Ex: "+e.getMessage());
			}
		}
	}
}
