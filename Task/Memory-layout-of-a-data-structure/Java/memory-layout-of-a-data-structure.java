public final class MemoryLayoutOfDataStructure {

	public static void main(String[] aArgs) {
		RS232Pins9 plug = new RS232Pins9();
		System.out.println(plug.getPin("receivedData"));
		plug.setPin(2, Status.ON);
		System.out.println(plug.getPin("receivedData"));
		plug.setPin("signalGround", Status.ON);
		plug.displayPinStatus();
	}
	
}

enum Status { OFF, ON }
	
final class RS232Pins9 {
	
	public Status getPin(int aPinNumber) {
		for ( Pin pin : Pin.values() ) {
			if ( pin.pinNumber == aPinNumber ) {
				return pin.status;
			}
		}
		throw new IllegalArgumentException("Unknown pin number: " + aPinNumber);
	}
	
	public Status getPin(String aName) {
		for ( Pin pin : Pin.values() ) {
			if ( pin.name() == aName ) {
				return pin.status;
			}
		}
		throw new IllegalArgumentException("Unknown pin name: " + aName);
	}
	
	public void setPin(int aPinNumber, Status aStatus) {
		for ( Pin pin : Pin.values() ) {
			if ( pin.pinNumber == aPinNumber ) {
				pin.status = aStatus;
			}
		}
	}
	
	public void setPin(String aName, Status aStatus) {
		for ( Pin pin : Pin.values() ) {
			if ( pin.name() == aName ) {
				pin.status = aStatus;
			}
		}
	}
	
	public void displayPinStatus() {
		for ( Pin pin : Pin.values() ) {
			System.out.println(String.format("%-29s%s", pin.name() + " has status ", pin.status));
		}			
	}
	
	private enum Pin {
		
		carrierDetect(1, Status.OFF), receivedData(2, Status.OFF), transmittedData(3, Status.OFF),
		dataTerminalReady(4, Status.OFF), signalGround(5, Status.OFF), dataSetReady(6, Status.OFF),
		requestToSend(7, Status.OFF), clearToSend(8, Status.OFF), ringIndicator(9, Status.OFF);
		
		private Pin(int aPinNumber, Status aStatus) {
			pinNumber = aPinNumber;
			status = aStatus;
		}
		
		private int pinNumber;
		private Status status;		
		
	}

}
