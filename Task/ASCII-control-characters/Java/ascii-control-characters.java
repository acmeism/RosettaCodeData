public final class ASCIIControlCharacters {

	public static void main(String[] args) {
		ASCIIControlChar syn = ASCIIControlChar.SYN;
		System.out.println(syn.name() + " " + syn.getText() + " " + syn.getNumber());
		
		ASCIIControlChar del = ASCIIControlChar.DEL;
		System.out.println(del.name() + " " + del.getText() + " " + del.getNumber());
	}
	
	private enum ASCIIControlChar {
		NUL("Null", 0), SOH("Start of Heading", 1), STX("Start of Text", 2), ETX("End of Text", 3),
		EOT("End of Transmission", 4), ENQ("Enquiry", 5), ACK("Acknowledge", 6), BEL("Bell", 7),
		BS("Backspace", 8), HT("Horizontal Tab", 9), LF("Line Feed", 10), VT("Vertical Tabulation", 11),
		FF("Form Feed", 12), CR("Carriage Return", 13),  SO("Shift Out", 14), SI("Shift In", 15),
        DLE("Data Link Escape", 16), DC1("Device Control One (XON)", 17), DC2("Device Control Two", 18),
        DC3("Device Control Three (XOFF)", 19), DC4("Device Control Four", 20),
        NAK("Negative Acknowledge", 21), SYN("Synchronous Idle", 22), ETB("End of Transmission Block", 23),
        CAN("Cancel", 24), EM("End of Medium", 25), SUB("Substitute", 26), ESC("Escape", 27),
        FS("File Separator", 28), GS("Group Separator", 29), RS("Record Separator", 30),
        US("Unit Separator", 31), DEL("Delete", 127);
		
		public String getText() {
			return text;
		}
		
		public int getNumber() {
			return number;
		}
		
		private ASCIIControlChar(String aText, int aNumber) {
			text = aText;
			number = aNumber;
		}
		
		private String text;
		private int number;
		
	}

}
