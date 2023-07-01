using System;

class Program
{
  public static bool JortSort<T>(T[] array) where T : IComparable, IEquatable<T>
  {
    // sort the array
    T[] originalArray = (T[]) array.Clone();
    Array.Sort(array);

    // compare to see if it was originally sorted
    for (var i = 0; i < originalArray.Length; i++)
    {
      if (!Equals(originalArray[i], array[i]))
      {
        return false;
      }
    }

    return true;
  }
}
