import static ExampleClass.pali; // or from wherever it is defined
import static ExampleClass.rPali; // or from wherever it is defined
import org.junit.*;
public class PalindromeTest extends junit.framework.TestCase {
    @Before
    public void setUp(){
        //runs before each test
        //set up instance variables, network connections, etc. needed for all tests
    }
    @After
    public void tearDown(){
        //runs after each test
        //clean up instance variables (close files, network connections, etc.).
    }

    /**
     * Test the pali(...) method.
     */
    @Test
    public void testNonrecursivePali() throws Exception {
        assertTrue(pali("abcba"));
        assertTrue(pali("aa"));
        assertTrue(pali("a"));
        assertTrue(pali(""));
        assertFalse(pali("ab"));
        assertFalse(pali("abcdba"));
    }
    /**
     * Test the rPali(...) method.
     */
    @Test
    public void testRecursivePali() throws Exception {
        assertTrue(rPali("abcba"));
        assertTrue(rPali("aa"));
        assertTrue(rPali("a"));
        assertTrue(rPali(""));
        assertFalse(rPali("ab"));
        assertFalse(rPali("abcdba"));
    }

    /**
     * Expect a WhateverExcpetion
     */
    @Test(expected=WhateverException.class)
    public void except(){
        //some code that should throw a WhateverException
    }
}
