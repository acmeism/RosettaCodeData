public final class BinaryCodedDecimal {

	public static void main(String[] args) {
		final BCD64 one = new BCD64(0x01);
		
		BCD64 n = new BCD64(0x19);
		System.out.println("%s + %s = %-5s or, in packed BCD, %10s + %s = %s"
			.formatted(n, one, n.add(one), n.packed(), one.packed(), n.add(one).packed()));		
		n = new BCD64(0x30);
		System.out.println("%s - %s = %-5s or, in packed BCD, %10s - %s = %s"
			.formatted(n, one, n.subtract(one), n.packed(), one.packed(), n.subtract(one).packed()));		
		n = new BCD64(0x99);
		System.out.println("%s + %s = %-5s or, in packed BCD, %10s + %s = %s"
			.formatted(n, one, n.add(one), n.packed(), one.packed(), n.add(one).packed()));
		System.out.println();
		n = new BCD64(0x19);
		System.out.println("%s + %s = %-5s or, in unpacked BCD, %14s + %s = %s"
			.formatted(n, one, n.add(one), n.unpacked(), one.unpacked(), n.add(one).unpacked()));		
		n = new BCD64(0x30);
		System.out.println("%s - %s = %-5s or, in unpacked BCD, %14s - %s = %s"
			.formatted(n, one, n.subtract(one), n.unpacked(), one.unpacked(), n.subtract(one).unpacked()));		
		n = new BCD64(0x99);
		System.out.println("%s + %s = %-5s or, in unpacked BCD, %14s + %s = %s"
			.formatted(n, one, n.add(one), n.unpacked(), one.unpacked(), n.add(one).unpacked()));		
	}
}

final class BCD64 {
	
	public BCD64(long aBits) {
		bits = aBits;
	}
	
	public BCD64 add(BCD64 other) {
		final long t1 = bits + 0x0666_6666_6666_6666L;
        final long t2 = t1 + other.bits;
        final long t3 = t1 ^ other.bits;
        final long t4 = ~( t2 ^ t3 ) & 0x1111_1111_1111_1110L;
        final long t5 = ( t4 >> 2 ) | ( t4 >> 3 );
        return new BCD64(t2 - t5);
	}
	
	public BCD64 subtract(BCD64 other) {
	    return add(other.negate());
	}
	
	public BCD64 negate() {
		final long t1 = -bits;
	    final long t2 = t1 + 0xFFFF_FFFF_FFFF_FFFFL;
	    final long t3 = t2 ^ 1;
	    final long t4 = ~( t2 ^ t3 ) & 0x1111_1111_1111_1110L;
	    final long t5 = ( t4 >> 2 ) | ( t4 >> 3 );
	    return new BCD64(t1 - t5);
	}
	
	public String packed() {
		return "0b" + Long.toBinaryString(bits);
	}
	
	public String unpacked() {
		String binary = Long.toBinaryString(bits);
		String result = "";
		int index = binary.length() - 4;
		while ( index > 0 ) {
			result = "0000" + binary.substring(index, index + 4) + result;
			index -= 4;
		}
		return "0b" + binary.substring(0, index + 4) + result;
	}
	
	public String toString() {
		return "0x" + Long.toHexString(bits);
	}
	
	private long bits;
	
}
