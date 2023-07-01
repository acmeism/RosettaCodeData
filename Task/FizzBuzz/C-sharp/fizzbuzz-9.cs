using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace FizzBuzz
{
    [TestClass]
    public class FizzBuzzTest
    {
        private FizzBuzz fizzBuzzer;

        [TestInitialize]
        public void Initialize()
        {
            fizzBuzzer = new FizzBuzz();
        }

        [TestMethod]
        public void Give4WillReturn4()
        {
            Assert.AreEqual("4", fizzBuzzer.FizzBuzzer(4));
        }

        [TestMethod]
        public void Give9WillReturnFizz()
        {
            Assert.AreEqual("Fizz", fizzBuzzer.FizzBuzzer(9));
        }

        [TestMethod]
        public void Give25WillReturnBuzz()
        {
            Assert.AreEqual("Buzz", fizzBuzzer.FizzBuzzer(25));
        }

        [TestMethod]
        public void Give30WillReturnFizzBuzz()
        {
            Assert.AreEqual("FizzBuzz", fizzBuzzer.FizzBuzzer(30));
        }

        [TestMethod]
        public void First15()
        {
            ICollection expected = new ArrayList
                {"1", "2", "Fizz", "4", "Buzz", "Fizz", "7", "8", "Fizz", "Buzz", "11", "Fizz", "13", "14", "FizzBuzz"};

            var actual = Enumerable.Range(1, 15).Select(x => fizzBuzzer.FizzBuzzer(x)).ToList();

            CollectionAssert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void From1To100_ToShowHowToGet100()
        {
            const int expected = 100;
            var actual = Enumerable.Range(1, 100).Select(x => fizzBuzzer.FizzBuzzer(x)).ToList();

            Assert.AreEqual(expected, actual.Count);
        }
    }

    public class FizzBuzz
    {
        private delegate string Xzzer(int value);
        private readonly IList<Xzzer> _functions = new List<Xzzer>();

        public FizzBuzz()
        {
            _functions.Add(x => x % 3 == 0 ? "Fizz" : "");
            _functions.Add(x => x % 5 == 0 ? "Buzz" : "");
        }

        public string FizzBuzzer(int value)
        {
            var result = _functions.Aggregate(String.Empty, (current, function) => current + function.Invoke(value));
            return String.IsNullOrEmpty(result) ? value.ToString(CultureInfo.InvariantCulture) : result;
        }
    }
}
