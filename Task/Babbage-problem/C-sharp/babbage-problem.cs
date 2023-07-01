namespace Babbage_Problem
{
    class iterateNumbers
    {
        public iterateNumbers()
        {
            long baseNumberSquared = 0; //the base number multiplied by itself
            long baseNumber = 0;  //the number to be squared, this one will be iterated

            do  //this sets up the loop
            {
                baseNumber += 1; //add one to the base number
                baseNumberSquared = baseNumber * baseNumber; //multiply the base number by itself and store the value as baseNumberSquared
            }
            while (Right6Digits(baseNumberSquared) != 269696); //this will continue the loop until the right 6 digits of the base number squared are 269,696

            Console.WriteLine("The smallest integer whose square ends in 269,696 is " + baseNumber);
            Console.WriteLine("The square is " + baseNumberSquared);

        }

        private long Right6Digits(long baseNumberSquared)
        {

            string numberAsString = baseNumberSquared.ToString(); //this is converts the number to a different type so it can be cut up

            if (numberAsString.Length < 6) { return baseNumberSquared; }; //if the number doesn't have 6 digits in it, just return it to try again.

            numberAsString = numberAsString.Substring(numberAsString.Length - 6);  //this extracts the last 6 digits from the number

            return long.Parse(numberAsString); //return the last 6 digits of the number

        }
    }
}}
