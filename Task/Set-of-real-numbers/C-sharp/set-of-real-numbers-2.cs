using Microsoft.VisualStudio.TestTools.UnitTesting;
using RosettaCode.SetOfRealNumbers;

namespace RosettaCode.SetOfRealNumbersTest
{
    [TestClass]
    public class SetTest
    {
        [TestMethod]
        public void TestUnion()
        {
            var set =
                new Set<double>(value => 0d < value && value <= 1d).Union(
                    new Set<double>(value => 0d <= value && value < 2d));
            Assert.IsTrue(set.Contains(0d));
            Assert.IsTrue(set.Contains(1d));
            Assert.IsFalse(set.Contains(2d));
        }

        [TestMethod]
        public void TestIntersection()
        {
            var set =
                new Set<double>(value => 0d <= value && value < 2d).Intersection(
                    new Set<double>(value => 1d < value && value <= 2d));
            Assert.IsFalse(set.Contains(0d));
            Assert.IsFalse(set.Contains(1d));
            Assert.IsFalse(set.Contains(2d));
        }

        [TestMethod]
        public void TestDifference()
        {
            var set =
                new Set<double>(value => 0d <= value && value < 3d).Difference(
                    new Set<double>(value => 0d < value && value < 1d));
            Assert.IsTrue(set.Contains(0d));
            Assert.IsTrue(set.Contains(1d));
            Assert.IsTrue(set.Contains(2d));

            set =
                new Set<double>(value => 0d <= value && value < 3d).Difference(
                    new Set<double>(value => 0d <= value && value <= 1d));
            Assert.IsFalse(set.Contains(0d));
            Assert.IsFalse(set.Contains(1d));
            Assert.IsTrue(set.Contains(2d));
        }
    }
}
