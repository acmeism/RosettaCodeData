using System;
class SubStringTestClass
{
   public static int CountSubStrings(this string testString, string testSubstring) =>
       testString?.Split(new [] { testSubstring }, StringSplitOptions.None)?.Length - 1 ?? 0;
}
