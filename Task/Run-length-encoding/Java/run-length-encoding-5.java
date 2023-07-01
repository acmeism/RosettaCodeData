import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class RunLengthEncodingTest {
	private RLE = new RunLengthEncoding();

	@Test
	public void encodingTest() {
		assertEquals("1W", RLE.encode("W"));
		assertEquals("4W", RLE.encode("WWWW"));
		assertEquals("5w4i7k3i6p5e4d2i1a",
				RLE.encode("wwwwwiiiikkkkkkkiiippppppeeeeeddddiia"));
		assertEquals("12B1N12B3N24B1N14B",
				RLE.encode("BBBBBBBBBBBBNBBBBBBBBBBBBNNNBBBBBBBBBBBBBBBBBBBBBBBBNBBBBBBBBBBBBBB"));
		assertEquals("12W1B12W3B24W1B14W",
				RLE.encode("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"));
		assertEquals("1W1B1W1B1W1B1W1B1W1B1W1B1W1B", RLE.encode("WBWBWBWBWBWBWB"));

	}

	@Test
	public void decodingTest() {
		assertEquals("W", RLE.decode("1W"));
		assertEquals("WWWW", RLE.decode("4W"));
		assertEquals("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW",
				RLE.decode("12W1B12W3B24W1B14W"));
		assertEquals("WBWBWBWBWBWBWB", RLE.decode("1W1B1W1B1W1B1W1B1W1B1W1B1W1B"));
		assertEquals("WBWBWBWBWBWBWB", RLE.decode("1W1B1W1B1W1B1W1B1W1B1W1B1W1B"));

	}
}
