using NUnit.Framework;
using PalindromeDetector.ConsoleApp;

namespace PalindromeDetector.VisualStudioTests
{
    [TestFixture]
    public class NunitTests
    {
        [Test]
        public void PalindromeDetectorCanUnderstandPalindrome()
        {
            //nunit.framework v2.0.50727
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
        [Test]
        public void PalindromeDetectorUnderstandsNonPalindrome()
        {
            bool notExpected = true;
            bool actual;
            actual = Program.IsPalindrome("NotAPalindrome");
            Assert.AreEqual(notExpected, actual);
            actual = Program.IsPalindromeNonRecursive("NotAPalindrome");
            Assert.AreEqual(notExpected, actual);
        }
    }
}
