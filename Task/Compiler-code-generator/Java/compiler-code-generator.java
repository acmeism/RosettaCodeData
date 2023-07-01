package codegenerator;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class CodeGenerator {
    final static int WORDSIZE = 4;

    static byte[] code = {};

    static Map<String, NodeType> str_to_nodes = new HashMap<>();
    static List<String> string_pool = new ArrayList<>();
    static List<String> variables = new ArrayList<>();
    static int string_count = 0;
    static int var_count = 0;

    static Scanner s;
    static NodeType[] unary_ops = {
        NodeType.nd_Negate, NodeType.nd_Not
    };
    static NodeType[] operators = {
        NodeType.nd_Mul, NodeType.nd_Div, NodeType.nd_Mod, NodeType.nd_Add, NodeType.nd_Sub,
        NodeType.nd_Lss, NodeType.nd_Leq, NodeType.nd_Gtr, NodeType.nd_Geq,
        NodeType.nd_Eql, NodeType.nd_Neq, NodeType.nd_And, NodeType.nd_Or
    };

    static enum Mnemonic {
        NONE, FETCH, STORE, PUSH, ADD, SUB, MUL, DIV, MOD, LT, GT, LE, GE, EQ, NE, AND, OR, NEG, NOT,
        JMP, JZ, PRTC, PRTS, PRTI, HALT
    }
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
        nd_None("", Mnemonic.NONE), nd_Ident("Identifier", Mnemonic.NONE), nd_String("String", Mnemonic.NONE), nd_Integer("Integer", Mnemonic.NONE), nd_Sequence("Sequence", Mnemonic.NONE),
        nd_If("If", Mnemonic.NONE),
        nd_Prtc("Prtc", Mnemonic.NONE), nd_Prts("Prts", Mnemonic.NONE), nd_Prti("Prti", Mnemonic.NONE), nd_While("While", Mnemonic.NONE),
        nd_Assign("Assign", Mnemonic.NONE),
        nd_Negate("Negate", Mnemonic.NEG), nd_Not("Not", Mnemonic.NOT), nd_Mul("Multiply", Mnemonic.MUL), nd_Div("Divide", Mnemonic.DIV), nd_Mod("Mod", Mnemonic.MOD), nd_Add("Add", Mnemonic.ADD),
        nd_Sub("Subtract", Mnemonic.SUB), nd_Lss("Less", Mnemonic.LT), nd_Leq("LessEqual", Mnemonic.LE),
        nd_Gtr("Greater", Mnemonic.GT), nd_Geq("GreaterEqual", Mnemonic.GE), nd_Eql("Equal", Mnemonic.EQ),
        nd_Neq("NotEqual", Mnemonic.NE), nd_And("And", Mnemonic.AND), nd_Or("Or", Mnemonic.OR);

        private final String name;
        private final Mnemonic m;

        NodeType(String name, Mnemonic m) {
            this.name = name;
            this.m = m;
        }
        Mnemonic getMnemonic() { return this.m; }

        @Override
        public String toString() { return this.name; }
    }
    static void appendToCode(int b) {
        code = Arrays.copyOf(code, code.length + 1);
        code[code.length - 1] = (byte) b;
    }
    static void emit_byte(Mnemonic m) {
        appendToCode(m.ordinal());
    }
    static void emit_word(int n) {
        appendToCode(n >> 24);
        appendToCode(n >> 16);
        appendToCode(n >> 8);
        appendToCode(n);
    }
    static void emit_word_at(int pos, int n) {
        code[pos] = (byte) (n >> 24);
        code[pos + 1] = (byte) (n >> 16);
        code[pos + 2] = (byte) (n >> 8);
        code[pos + 3] = (byte) n;
    }
    static int get_word(int pos) {
        int result;
        result = ((code[pos] & 0xff) << 24) + ((code[pos + 1] & 0xff)  << 16) + ((code[pos + 2] & 0xff)  << 8) + (code[pos + 3] & 0xff) ;

        return result;
    }
    static int fetch_var_offset(String name) {
        int n;
        n = variables.indexOf(name);
        if (n == -1) {
            variables.add(name);
            n = var_count++;
        }
        return n;
    }
    static int fetch_string_offset(String str) {
        int n;
        n = string_pool.indexOf(str);
        if (n == -1) {
            string_pool.add(str);
            n = string_count++;
        }
        return n;
    }
    static int hole() {
        int t = code.length;
        emit_word(0);
        return t;
    }
    static boolean arrayContains(NodeType[] a, NodeType n) {
        boolean result = false;
        for (NodeType test: a) {
            if (test.equals(n)) {
                result = true;
                break;
            }
        }
        return result;
    }
    static void code_gen(Node x) throws Exception {
        int n, p1, p2;
        if (x == null) return;

        switch (x.nt) {
            case nd_None: return;
            case nd_Ident:
                emit_byte(Mnemonic.FETCH);
                n = fetch_var_offset(x.value);
                emit_word(n);
                break;
            case nd_Integer:
                emit_byte(Mnemonic.PUSH);
                emit_word(Integer.parseInt(x.value));
                break;
            case nd_String:
                emit_byte(Mnemonic.PUSH);
                n = fetch_string_offset(x.value);
                emit_word(n);
                break;
            case nd_Assign:
                n = fetch_var_offset(x.left.value);
                code_gen(x.right);
                emit_byte(Mnemonic.STORE);
                emit_word(n);
                break;
            case nd_If:
                p2 = 0; // to avoid NetBeans complaining about 'not initialized'
                code_gen(x.left);
                emit_byte(Mnemonic.JZ);
                p1 = hole();
                code_gen(x.right.left);
                if (x.right.right != null) {
                    emit_byte(Mnemonic.JMP);
                    p2 = hole();
                }
                emit_word_at(p1, code.length - p1);
                if (x.right.right != null) {
                    code_gen(x.right.right);
                    emit_word_at(p2, code.length - p2);
                }
                break;
            case nd_While:
                p1 = code.length;
                code_gen(x.left);
                emit_byte(Mnemonic.JZ);
                p2 = hole();
                code_gen(x.right);
                emit_byte(Mnemonic.JMP);
                emit_word(p1 - code.length);
                emit_word_at(p2, code.length - p2);
                break;
            case nd_Sequence:
                code_gen(x.left);
                code_gen(x.right);
                break;
            case nd_Prtc:
                code_gen(x.left);
                emit_byte(Mnemonic.PRTC);
                break;
            case nd_Prti:
                code_gen(x.left);
                emit_byte(Mnemonic.PRTI);
                break;
            case nd_Prts:
                code_gen(x.left);
                emit_byte(Mnemonic.PRTS);
                break;
            default:
                if (arrayContains(operators, x.nt)) {
                    code_gen(x.left);
                    code_gen(x.right);
                    emit_byte(x.nt.getMnemonic());
                } else if (arrayContains(unary_ops, x.nt)) {
                    code_gen(x.left);
                    emit_byte(x.nt.getMnemonic());
                } else {
                    throw new Exception("Error in code generator! Found " + x.nt + ", expecting operator.");
                }
        }
    }
    static void list_code() throws Exception {
        int pc = 0, x;
        Mnemonic op;
        System.out.println("Datasize: " + var_count + " Strings: " + string_count);
        for (String s: string_pool) {
            System.out.println(s);
        }
        while (pc < code.length) {
            System.out.printf("%4d ", pc);
            op = Mnemonic.values()[code[pc++]];
            switch (op) {
                case FETCH:
                    x = get_word(pc);
                    System.out.printf("fetch [%d]", x);
                    pc += WORDSIZE;
                    break;
                case STORE:
                    x = get_word(pc);
                    System.out.printf("store [%d]", x);
                    pc += WORDSIZE;
                    break;
                case PUSH:
                    x = get_word(pc);
                    System.out.printf("push  %d", x);
                    pc += WORDSIZE;
                    break;
                case ADD: case SUB: case MUL: case DIV: case MOD:
                case LT: case GT: case LE: case GE: case EQ: case NE:
                case AND: case OR: case NEG: case NOT:
                case PRTC: case PRTI: case PRTS: case HALT:
                    System.out.print(op.toString().toLowerCase());
                    break;
                case JMP:
                    x = get_word(pc);
                    System.out.printf("jmp     (%d) %d", x, pc + x);
                    pc += WORDSIZE;
                    break;
                case JZ:
                    x = get_word(pc);
                    System.out.printf("jz      (%d) %d", x, pc + x);
                    pc += WORDSIZE;
                    break;
                default:
                    throw new Exception("Unknown opcode " + code[pc] + "@" + (pc - 1));
            }
            System.out.println();
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
                code_gen(n);
                emit_byte(Mnemonic.HALT);
                list_code();
            } catch (Exception e) {
                System.out.println("Ex: "+e);//.getMessage());
            }
        }
    }
}
