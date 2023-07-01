public class LongMult {

	private static byte[] stringToDigits(String num) {
		byte[] result = new byte[num.length()];
		for (int i = 0; i < num.length(); i++) {
			char c = num.charAt(i);
			if (c < '0' || c > '9') {
				throw new IllegalArgumentException("Invalid digit " + c
						+ " found at position " + i);
			}
			result[num.length() - 1 - i] = (byte) (c - '0');
		}
		return result;
	}

	public static String longMult(String num1, String num2) {
		byte[] left = stringToDigits(num1);
		byte[] right = stringToDigits(num2);
		byte[] result = new byte[left.length + right.length];
		for (int rightPos = 0; rightPos < right.length; rightPos++) {
			byte rightDigit = right[rightPos];
			byte temp = 0;
			for (int leftPos = 0; leftPos < left.length; leftPos++) {
				temp += result[leftPos + rightPos];
				temp += rightDigit * left[leftPos];
				result[leftPos + rightPos] = (byte) (temp % 10);
				temp /= 10;
			}
			int destPos = rightPos + left.length;
			while (temp != 0) {
				temp += result[destPos] & 0xFFFFFFFFL;
				result[destPos] = (byte) (temp % 10);
				temp /= 10;
				destPos++;
			}
		}
		StringBuilder stringResultBuilder = new StringBuilder(result.length);
		for (int i = result.length - 1; i >= 0; i--) {
			byte digit = result[i];
			if (digit != 0 || stringResultBuilder.length() > 0) {
				stringResultBuilder.append((char) (digit + '0'));
			}
		}
		return stringResultBuilder.toString();
	}

	public static void main(String[] args) {
		System.out.println(longMult("18446744073709551616",
				"18446744073709551616"));
	}
}
