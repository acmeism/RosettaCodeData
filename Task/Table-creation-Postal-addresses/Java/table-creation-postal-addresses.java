import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public final class TableCreationPostalAddresses {

	public static void main(String[] args) throws IOException {	
		Address[] addresses = new Address[] {
			new Address("FSF Inc.", "51 Franklin Street", "Boston", "MA", "02110-1301"),
			new Address("The White House", "1600 Pennsylvania Avenue NW", "Washington", "DC", "20500"),
			new Address("National Security Council", "1700 Pennsylvania Avenue NW", "Washington", "DC", "20500")
		};
		
        Path path = Path.of("addresses.dat");
		FileChannel fileChannel = FileChannel.open(path, StandardOpenOption.CREATE,
														 StandardOpenOption.READ,
														 StandardOpenOption.WRITE);			
		for ( int i = 0; i < addresses.length; i++ ) {
			byte[] data = addresses[i].addressRecord().getBytes();
		    ByteBuffer writeBuffer = ByteBuffer.wrap(data);
		    fileChannel.position(i * Address.RECORD_LENGTH);
		    while ( writeBuffer.hasRemaining() ) {
		        fileChannel.write(writeBuffer);
		    }			
		}
		
		for ( int i = 0; i < addresses.length; i++ ) {
			fileChannel.position(i * Address.RECORD_LENGTH);
			ByteBuffer readBuffer = ByteBuffer.allocate(Address.RECORD_LENGTH);
			fileChannel.read(readBuffer);
		    System.out.println( new String(readBuffer.array()) );			
		}
		
		fileChannel.close();
	}
	
}

final class Address {
	
	public Address(String aName, String aStreet, String aCity, String aState, String aZipCode) {
		name = aName; street = aStreet; city = aCity; state = aState; zipCode = aZipCode;
	}
	
	public String addressRecord() {
		String record = "";
		record += String.format("%-30s", name);
		record += String.format("%-30s", street);
		record += String.format("%-15s", city);
		record += String.format("%-5s", state);
		record += String.format("%-10s", zipCode);
		return record;		
	}
	
	public static final int RECORD_LENGTH = 30 + 30 + 15 + 5 + 10;
	
	private String name, street, city, state, zipCode;
	
}
