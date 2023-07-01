import java.util.LinkedList;

public class RPN{
	public static void main(String[] args) {
		evalRPN("3 4 2 * 1 5 - 2 3 ^ ^ / +");
	}

	private static void evalRPN(String expr){
		LinkedList<Double> stack = new LinkedList<Double>();
		System.out.println("Input\tOperation\tStack after");
		for (String token : expr.split("\\s")){
			System.out.print(token + "\t");
			if (token.equals("*")) {
				System.out.print("Operate\t\t");
				double secondOperand = stack.pop();
				double firstOperand = stack.pop();
				stack.push(firstOperand * secondOperand);
			} else if (token.equals("/")) {
				System.out.print("Operate\t\t");
				double secondOperand = stack.pop();
				double firstOperand = stack.pop();
				stack.push(firstOperand / secondOperand);
			} else if (token.equals("-")) {
				System.out.print("Operate\t\t");
				double secondOperand = stack.pop();
				double firstOperand = stack.pop();
				stack.push(firstOperand - secondOperand);
			} else if (token.equals("+")) {
				System.out.print("Operate\t\t");
				double secondOperand = stack.pop();
				double firstOperand = stack.pop();
				stack.push(firstOperand + secondOperand);
			} else if (token.equals("^")) {
				System.out.print("Operate\t\t");
				double secondOperand = stack.pop();
				double firstOperand = stack.pop();
				stack.push(Math.pow(firstOperand, secondOperand));
			} else {
				System.out.print("Push\t\t");
				try {
					stack.push(Double.parseDouble(token+""));
				} catch (NumberFormatException e) {
    					System.out.println("\nError: invalid token " + token);
    					return;
				}
			}
			System.out.println(stack);
		}
		if (stack.size() > 1) {
			System.out.println("Error, too many operands: " + stack);
			return;
		}
		System.out.println("Final answer: " + stack.pop());
	}
}
