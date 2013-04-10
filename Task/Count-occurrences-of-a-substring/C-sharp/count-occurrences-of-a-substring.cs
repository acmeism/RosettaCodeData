using System;

class SubStringTestClass
{
   public static int CountSubStrings(this string testString, string testSubstring)
        {
            int count = 0;

            if (testString.Contains(testSubstring))
            {
                for (int i = 0; i < testString.Length; i++)
                {
                    if (testString.Substring(i).Length >= testSubstring.Length)
                    {
                        bool equals = testString.Substring(i, testSubstring.Length).Equals(testSubstring);
                        if (equals)
                        {
                            count++;
                            i += testSubstring.Length - 1;  // Fix: Don't count overlapping matches
                        }
                    }
                }
            }
            return count;
        }
}
