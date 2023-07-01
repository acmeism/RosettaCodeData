using Microsoft.VisualStudio.TestTools.UnitTesting;
using PalindromeDetector.ConsoleApp;

namespace PalindromeDetector.VisualStudioTests
{
    [TestClass]
    public class VSTests
    {
        [TestMethod]
        public void PalindromeDetectorCanUnderstandPalindrome()
        {
            //Microsoft.VisualStudio.QualityTools.UnitTestFramework v4.0.30319
            bool expected = true;
            bool actual;
            actual = Program.IsPalindrome("1");
            Assert.AreEqual(expected, actual);
            actual = Program.IsPalindromeNonRecursive("1");
            Assert.AreEqual(expected, actual);
            actual = Program.IsPalindrome("ingirumimusnocteetconsumimurigni");
            Assert.AreEqual(expected, actual);
            actual = Program.IsPalindromeNonRecursive("ingirumimusnocteetconsumimurigni");
            Assert.AreEqual(expected, actual);
        }
        [TestMethod]
        public void PalindromeDetecotryCanUnderstandNonPalindrome()
        {
            bool notExpected = true;
            bool actual = Program.IsPalindrome("ThisIsNotAPalindrome");
            Assert.AreNotEqual(notExpected, actual);
            actual = Program.IsPalindromeNonRecursive("ThisIsNotAPalindrome");
            Assert.AreNotEqual(notExpected, actual);
        }
    }
}
