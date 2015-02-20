import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Random;


public class IsaacRandom extends Random {
	
	private static final long serialVersionUID = 1L;
	
	private final int[] randResult = new int[256];    // output of last generation
	private int valuesUsed;                           // the number of values already used up from randResult
	
	// internal generator state
	private final int[] mm = new int[256];
	private int aa, bb, cc;
	
	public IsaacRandom() {
		super(0);
		init(null);
	}
	
	public IsaacRandom(int[] seed) {
		super(0);
		setSeed(seed);
	}
	
	public IsaacRandom(String seed) {
		super(0);
		setSeed(seed);
	}
	
	private void generateMoreResults() {
		cc++;
		bb += cc;
		
		for (int i=0; i<256; i++) {
			int x = mm[i];
			switch (i&3) {
			case 0:
				aa = aa^(aa<<13);
				break;
			case 1:
				aa = aa^(aa>>>6);
				break;
			case 2:
				aa = aa^(aa<<2);
				break;
			case 3:
				aa = aa^(aa>>>16);
				break;
			}
			aa = mm[i^128] + aa;
			int y = mm[i] = mm[(x>>>2) & 0xFF] + aa + bb;
			randResult[i] = bb = mm[(y>>>10) & 0xFF] + x;
		}
		
		valuesUsed = 0;
	}
	
	private static void mix(int[] s) {
		   s[0]^=s[1]<<11;  s[3]+=s[0]; s[1]+=s[2];
		   s[1]^=s[2]>>>2;  s[4]+=s[1]; s[2]+=s[3];
		   s[2]^=s[3]<<8;   s[5]+=s[2]; s[3]+=s[4];
		   s[3]^=s[4]>>>16; s[6]+=s[3]; s[4]+=s[5];
		   s[4]^=s[5]<<10;  s[7]+=s[4]; s[5]+=s[6];
		   s[5]^=s[6]>>>4;  s[0]+=s[5]; s[6]+=s[7];
		   s[6]^=s[7]<<8;   s[1]+=s[6]; s[7]+=s[0];
		   s[7]^=s[0]>>>9;  s[2]+=s[7]; s[0]+=s[1];
	}
	
	private void init(int[] seed) {
		if (seed != null && seed.length != 256) {
			seed = Arrays.copyOf(seed, 256);
		}
		aa = bb = cc = 0;
		int[] initState = new int[8];
		Arrays.fill(initState, 0x9e3779b9);	// the golden ratio
		
		for (int i=0; i<4; i++) {
			mix(initState);
		}
		
		for (int i=0; i<256; i+=8) {
			if (seed != null) {
				for (int j=0; j<8; j++) {
					initState[j] += seed[i+j];
				}
			}
			mix(initState);
			for (int j=0; j<8; j++) {
				mm[i+j] = initState[j];
			}
		}
		
		if (seed != null) {
			for (int i=0; i<256; i+=8) {
				for (int j=0; j<8; j++) {
					initState[j] += mm[i+j];
				}
				
				mix(initState);
				
				for (int j=0; j<8; j++) {
					mm[i+j] = initState[j];
				}
			}
		}
		
		valuesUsed = 256;	// Make sure generateMoreResults() will be called by the next next() call.
	}
	
	@Override
	protected int next(int bits) {
		if (valuesUsed == 256) {
			generateMoreResults();
			assert(valuesUsed == 0);
		}
		int value = randResult[valuesUsed];
		valuesUsed++;
		return value >>> (32-bits);
	}
	
	@Override
	public synchronized void setSeed(long seed) {
		super.setSeed(0);
		if (mm == null) {
			// We're being called from the superclass constructor. We don't have our
			// state arrays instantiated yet, and we're going to do proper initialization
			// later in our own constructor anyway, so just ignore this call.
			return;
		}
		int[] arraySeed = new int[256];
		arraySeed[0] = (int) (seed & 0xFFFFFFFF);
		arraySeed[1] = (int) (seed >>> 32);
		init(arraySeed);
	}
	
	public synchronized void setSeed(int[] seed) {
		super.setSeed(0);
		init(seed);
	}
	
	public synchronized void setSeed(String seed) {
		super.setSeed(0);
		char[] charSeed = seed.toCharArray();
		int[] intSeed = new int[charSeed.length];
		for (int i=0; i<charSeed.length; i++) {
			intSeed[i] = charSeed[i];
		}
		init(intSeed);
	}
	
	public int randomChar() {
		long unsignedNext = nextInt() & 0xFFFFFFFFL;	// The only way to force unsigned modulo behavior in Java is to convert to a long and mask off the copies of the sign bit.
		return (int) (unsignedNext % 95 + 32);		    // nextInt(95) + 32 would yield a more equal distribution, but then we would be incompatible with the original C code
	}
	
	public enum CipherMode { ENCIPHER, DECIPHER, NONE };
	
	public byte[] vernamCipher(byte[] input) {
		byte[] result = new byte[input.length];
		for (int i=0; i<input.length; i++) {
			result[i] = (byte) (randomChar() ^ input[i]);
		}
		return result;
	}
	
	private static byte caesarShift(CipherMode mode, byte ch, int shift, byte modulo, byte start) {
		if (mode == CipherMode.DECIPHER) {
			shift = -shift;
		}
		int n = (ch-start) + shift;
		n %= modulo;
		if (n<0) {
			n += modulo;
		}
		return (byte) (start + n);
	}
	
	public byte[] caesarCipher(CipherMode mode, byte[] input, byte modulo, byte start) {
		byte[] result = new byte[input.length];
		for (int i=0; i<input.length; i++) {
			result[i] = caesarShift(mode, input[i], randomChar(), modulo, start);
		}
		return result;
	}
	
	private static String toHexString(byte[] input) {
		// NOTE: This method prefers simplicity over performance.
		StringBuilder sb = new StringBuilder(input.length*2);
		for (byte b : input) {
			sb.append(String.format("%02X", b));
		}
		return sb.toString();
	}
	
	public static void main(String[] args) {
		final byte MOD = 95;
		final byte START = 32;
		
		String secret = "a Top Secret secret";
		String key = "this is my secret key";
		
		IsaacRandom random = new IsaacRandom(key);
		byte[] vernamResult;
		byte[] caesarResult;
		String vernamDecrypted;
		String caesarDecrypted;
		try {
			vernamResult = random.vernamCipher(secret.getBytes("ASCII"));
			caesarResult = random.caesarCipher(CipherMode.ENCIPHER, secret.getBytes("ASCII"), MOD, START);
			random.setSeed(key);
			vernamDecrypted = new String(random.vernamCipher(vernamResult), "ASCII");
			caesarDecrypted = new String(random.caesarCipher(CipherMode.DECIPHER, caesarResult, MOD, START), "ASCII");
		} catch (UnsupportedEncodingException e) {
			throw new InternalError("JVM isn't conforming - ASCII encoding isn't available");
		}
		System.out.printf("Message: %s\n", secret);
		System.out.printf("Key    : %s\n", key);
		System.out.printf("XOR    : %s\n", toHexString(vernamResult));
		System.out.printf("XOR dcr: %s\n", vernamDecrypted);
		System.out.printf("MOD    : %s\n", toHexString(caesarResult));
		System.out.printf("MOD dcr: %s\n", caesarDecrypted);
	}
}
