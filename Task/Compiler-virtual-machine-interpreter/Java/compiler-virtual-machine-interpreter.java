import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

public final class CompilerVirtualMachineInterpreter {

	public static void main(String[] args) throws IOException {
		Path filePath = Path.of("Compiler Test Cases/AsciiMandlebrot.txt");
		VirtualMachineInfo info = loadCode(filePath);		
		runVirtualMachine(info.dataSize, info.vmStrings, info.codes());
	}

	private static void runVirtualMachine(int dataSize, List<String> vmStrings, List<Byte> codes) {	
		final int wordSize = 4;
		Stack<Integer> stack = new Stack<Integer>();
		for ( int i = 0; i < dataSize; i++ ) {
    		stack.push(0);
    	}
		
		int index = 0;
		OpCode opCode = null;
		
		while ( opCode != OpCode.HALT ) {
			opCode = OpCode.havingCode(codes.get(index));
			index += 1;
			
			switch ( opCode ) {
				case HALT  -> { }
			    case ADD   -> stack.set(stack.size() - 2, stack.get(stack.size() - 2) + stack.pop());
		        case SUB   -> stack.set(stack.size() - 2, stack.get(stack.size() - 2) - stack.pop());
		        case MUL   -> stack.set(stack.size() - 2, stack.get(stack.size() - 2) * stack.pop());
		        case DIV   -> stack.set(stack.size() - 2, stack.get(stack.size() - 2) / stack.pop());
		        case MOD   -> stack.set(stack.size() - 2, Math.floorMod(stack.get(stack.size() - 2), stack.pop()));
		        case LT    -> stack.set(stack.size() - 2, ( stack.get(stack.size() - 2) < stack.pop() ) ? 1 : 0);
		        case GT    -> stack.set(stack.size() - 2, ( stack.get(stack.size() - 2) > stack.pop() ) ? 1 : 0);
		        case LE    -> stack.set(stack.size() - 2, ( stack.get(stack.size() - 2) <= stack.pop() ) ? 1 : 0);
		        case GE    -> stack.set(stack.size() - 2, ( stack.get(stack.size() - 2) >= stack.pop() ) ? 1 : 0);
		        case EQ    -> stack.set(stack.size() - 2, ( stack.get(stack.size() - 2) == stack.pop() ) ? 1 : 0);
		        case NE    -> stack.set(stack.size() - 2, ( stack.get(stack.size() - 2) != stack.pop() ) ? 1 : 0);
		        case AND   -> { final int value = ( stack.get(stack.size() - 2) != 0 && stack.pop() != 0 ) ? 1 : 0;
		        				stack.set(stack.size() - 1, value);
		        			  }
		        case OR    -> { final int value = ( stack.get(stack.size() - 2) != 0 || stack.pop() != 0 ) ? 1 : 0;
			    				stack.set(stack.size() - 1, value);
			    			  }
		        case NEG   -> stack.set(stack.size() - 1, -stack.peek());
		        case NOT   -> stack.set(stack.size() - 1, ( stack.peek() == 0 ) ? 1 : 0);
		        case PRTC  -> System.out.print((char) stack.pop().intValue());
		        case PRTI  -> System.out.print(stack.pop());
		        case PRTS  -> System.out.print(vmStrings.get(stack.pop()));
		        case FETCH -> { stack.push(stack.get(operand(index, codes))); index += wordSize; }		
		        case STORE -> { stack.set(operand(index, codes), stack.pop()); index += wordSize; }
		        case PUSH  -> { stack.push(operand(index, codes)); index += wordSize; }
		        case JMP   -> index += operand(index, codes);
		        case JZ    -> index += ( stack.pop() == 0 ) ? operand(index, codes) : wordSize;		
		    } 			
		}
	}
	
	private static VirtualMachineInfo loadCode(Path filePath) throws IOException {
		List<String> lines = Files.readAllLines(filePath, StandardCharsets.UTF_8);
		
		String line = lines.getFirst();		
		if ( line.startsWith("lex") ) {
			lines.removeFirst();
			line = lines.getFirst();		
		}
		
		String[] sections = line.trim().split(" ");			
		final int dataSize = Integer.parseInt(sections[1]);
		final int stringCount = Integer.parseInt(sections[3]);
		
		List<String> VMstrings = new ArrayList<String>();
		for ( int i = 1; i <= stringCount; i++ ) {
			String content = lines.get(i).substring(1, lines.get(i).length() - 1);				
			VMstrings.addLast(parseString(content));
		}
	
		int offset = 0;
		List<Byte> codes = new ArrayList<Byte>();
		for ( int i = stringCount + 1; i < lines.size(); i++ ) {
			sections = lines.get(i).trim().split("\\s+");		
			offset = Integer.parseInt(sections[0]);			
			OpCode opCode = OpCode.valueOf(sections[1].toUpperCase());
			codes.addLast(opCode.byteCode());
			
			switch ( opCode ) {				
				case FETCH, STORE -> addToCodes(Integer.parseInt(sections[2]
										.substring(1, sections[2].length() - 1)), codes);
				case PUSH         -> addToCodes(Integer.parseInt(sections[2]), codes);		
				case JMP, JZ      -> addToCodes(Integer.parseInt(sections[3]) - offset - 1, codes);				
				default           -> { }
			}	
		}
	
		return new VirtualMachineInfo(dataSize, VMstrings, codes);
	}
	
	private static int operand(int index, List<Byte> codes) {
		byteBuffer.clear();
		for ( int i = index; i < index + 4; i++ ) {
			byteBuffer.put(codes.get(i));
		}
		byteBuffer.flip();
		
		return byteBuffer.getInt();
	}
	
	private static void addToCodes(int number, List<Byte> codes) {
		byteBuffer.clear();
		byteBuffer.putInt(number);
		byteBuffer.flip();
		for ( byte bb : byteBuffer.array() ) {
			codes.addLast(bb);
		}
	}
	
	private static String parseString(String text) {
	    StringBuilder result = new StringBuilder();
	    int i = 0;
	    while ( i < text.length() ) {
	        if ( text.charAt(i) == '\\' && i + 1 < text.length() ) {
	            if ( text.charAt(i + 1) == 'n' ) {
	                result.append("\n");
	                i += 1;
	            } else if ( text.charAt(i + 1) == '\\') {
	                result.append("\\");
	                i += 1;
	            }
	        } else {
	            result.append(text.charAt(i));
	        }
	        i += 1;
	    }
	
	    return result.toString();
	}
	
	private static ByteBuffer byteBuffer = ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN);
	
	private static enum OpCode {
		
		HALT(0), ADD(1), SUB(2), MUL(3), DIV(4), MOD(5), LT(6), GT(7), LE(8), GE(9), EQ(10), NE(11),
		AND(12), OR(13), NEG(14), NOT(15),
		PRTC(16), PRTI(17), PRTS(18), FETCH(19), STORE(20), PUSH(21), JMP(22), JZ(23);
		
		public byte byteCode() {
			return (byte) byteCode;
		}
		
		public static OpCode havingCode(Byte byteCode) {
			return op_codes[(int) byteCode];
		}
		
		private OpCode(int aByteCode) {
			byteCode = aByteCode;
		}
		
		private int byteCode;
		
		private static OpCode[] op_codes = values();
		
	}
	
	private static record VirtualMachineInfo(int dataSize, List<String> vmStrings, List<Byte> codes) {}	

}
