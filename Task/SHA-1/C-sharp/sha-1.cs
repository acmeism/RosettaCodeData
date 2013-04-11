using System;
using System.Security.Cryptography;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace RosettaCode.SHA1
{
    [TestClass]
    public class SHA1CryptoServiceProviderTest
    {
        [TestMethod]
        public void TestComputeHash()
        {
            var input = new UTF8Encoding().GetBytes("Rosetta Code");
            var output = new SHA1CryptoServiceProvider().ComputeHash(input);
            Assert.AreEqual(
                "48-C9-8F-7E-5A-6E-73-6D-79-0A-B7-40-DF-C3-F5-1A-61-AB-E2-B5",
                BitConverter.ToString(output));
        }
    }
}
