using System;
using System.Security.Cryptography;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace RosettaCode.SHA256
{
    [TestClass]
    public class SHA256ManagedTest
    {
        [TestMethod]
        public void TestComputeHash()
        {
            var buffer = Encoding.UTF8.GetBytes("Rosetta code");
            var hashAlgorithm = new SHA256Managed();
            var hash = hashAlgorithm.ComputeHash(buffer);
            Assert.AreEqual(
                "76-4F-AF-5C-61-AC-31-5F-14-97-F9-DF-A5-42-71-39-65-B7-85-E5-CC-2F-70-7D-64-68-D7-D1-12-4C-DF-CF",
                BitConverter.ToString(hash));
        }
    }
}
