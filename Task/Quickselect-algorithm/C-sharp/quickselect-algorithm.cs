// ----------------------------------------------------------------------------------------------
//
//  Program.cs - QuickSelect
//
// ----------------------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Linq;

namespace QuickSelect
{
    internal static class Program
    {
        #region Static Members

        private static void Main()
        {
            var inputArray = new[] {9, 8, 7, 6, 5, 0, 1, 2, 3, 4};
            // Loop 10 times
            Console.WriteLine( "Loop quick select 10 times." );
            for( var i = 0 ; i < 10 ; i++ )
            {
                Console.Write( inputArray.NthSmallestElement( i ) );
                if( i < 9 )
                    Console.Write( ", " );
            }
            Console.WriteLine();

            // And here is then more effective way to get N smallest elements from vector in order by using quick select algorithm
            // Basically we are here just sorting array (taking 10 smallest from array which length is 10)
            Console.WriteLine( "Just sort 10 elements." );
            Console.WriteLine( string.Join( ", ", inputArray.TakeSmallest( 10 ).OrderBy( v => v ).Select( v => v.ToString() ).ToArray() ) );
            // Here we are actually doing quick select once by taking only 4 smallest from array.
            Console.WriteLine( "Get 4 smallest and sort them." );
            Console.WriteLine( string.Join( ", ", inputArray.TakeSmallest( 4 ).OrderBy( v => v ).Select( v => v.ToString() ).ToArray() ) );
            Console.WriteLine( "< Press any key >" );
            Console.ReadKey();
        }

        #endregion
    }

    internal static class ArrayExtension
    {
        #region Static Members

        /// <summary>
        ///  Return specified number of smallest elements from array.
        /// </summary>
        /// <typeparam name="T">The type of the elements of array. Type must implement IComparable(T) interface.</typeparam>
        /// <param name="array">The array to return elemnts from.</param>
        /// <param name="count">The number of smallest elements to return. </param>
        /// <returns>An IEnumerable(T) that contains the specified number of smallest elements of the input array. Returned elements are NOT sorted.</returns>
        public static IEnumerable<T> TakeSmallest<T>( this T[] array, int count ) where T : IComparable<T>
        {
            if( count < 0 )
                throw new ArgumentOutOfRangeException( "count", "Count is smaller than 0." );
            if( count == 0 )
                return new T[0];
            if( array.Length <= count )
                return array;

            return QuickSelectSmallest( array, count - 1 ).Take( count );
        }

        /// <summary>
        /// Returns N:th smallest element from the array.
        /// </summary>
        /// <typeparam name="T">The type of the elements of array. Type must implement IComparable(T) interface.</typeparam>
        /// <param name="array">The array to return elemnt from.</param>
        /// <param name="n">Nth element. 0 is smallest element, when array.Length - 1 is largest element.</param>
        /// <returns>N:th smalles element from the array.</returns>
        public static T NthSmallestElement<T>( this T[] array, int n ) where T : IComparable<T>
        {
            if( n < 0 || n > array.Length - 1 )
                throw new ArgumentOutOfRangeException( "n", n, string.Format( "n should be between 0 and {0} it was {1}.", array.Length - 1, n ) );
            if( array.Length == 0 )
                throw new ArgumentException( "Array is empty.", "array" );
            if( array.Length == 1 )
                return array[ 0 ];

            return QuickSelectSmallest( array, n )[ n ];
        }

        /// <summary>
        ///  Partially sort array such way that elements before index position n are smaller or equal than elemnt at position n. And elements after n are larger or equal.
        /// </summary>
        /// <typeparam name="T">The type of the elements of array. Type must implement IComparable(T) interface.</typeparam>
        /// <param name="input">The array which elements are being partially sorted. This array is not modified.</param>
        /// <param name="n">Nth smallest element.</param>
        /// <returns>Partially sorted array.</returns>
        private static T[] QuickSelectSmallest<T>( T[] input, int n ) where T : IComparable<T>
        {
            // Let's not mess up with our input array
            // For very large arrays - we should optimize this somehow - or just mess up with our input
            var partiallySortedArray = (T[]) input.Clone();

            // Initially we are going to execute quick select to entire array
            var startIndex = 0;
            var endIndex = input.Length - 1;

            // Selecting initial pivot
            // Maybe we are lucky and array is sorted initially?
            var pivotIndex = n;

            // Loop until there is nothing to loop (this actually shouldn't happen - we should find our value before we run out of values)
            var r = new Random();
            while( endIndex > startIndex )
            {
                pivotIndex = QuickSelectPartition( partiallySortedArray, startIndex, endIndex, pivotIndex );
                if( pivotIndex == n )
                    // We found our n:th smallest value - it is stored to pivot index
                    break;
                if( pivotIndex > n )
                    // Array before our pivot index have more elements that we are looking for
                    endIndex = pivotIndex - 1;
                else
                    // Array before our pivot index has less elements that we are looking for
                    startIndex = pivotIndex + 1;

                // Omnipotent beings don't need to roll dices - but we do...
                // Randomly select a new pivot index between end and start indexes (there are other methods, this is just most brutal and simplest)
                pivotIndex = r.Next( startIndex,  endIndex );
            }
            return partiallySortedArray;
        }

        /// <summary>
        /// Sort elements in sub array between startIndex and endIndex, such way that elements smaller than or equal with value initially stored to pivot index are before
        /// new returned pivot value index.
        /// </summary>
        /// <typeparam name="T">The type of the elements of array. Type must implement IComparable(T) interface.</typeparam>
        /// <param name="array">The array that is being sorted.</param>
        /// <param name="startIndex">Start index of sub array.</param>
        /// <param name="endIndex">End index of sub array.</param>
        /// <param name="pivotIndex">Pivot index.</param>
        /// <returns>New pivot index. Value that was initially stored to <paramref name="pivotIndex"/> is stored to this newly returned index. All elements before this index are
        /// either smaller or equal with pivot value. All elements after this index are larger than pivot value.</returns>
        /// <remarks>This method modifies paremater array.</remarks>
        private static int QuickSelectPartition<T>( this T[] array, int startIndex, int endIndex, int pivotIndex ) where T : IComparable<T>
        {
            var pivotValue = array[ pivotIndex ];
            // Initially we just assume that value in pivot index is largest - so we move it to end (makes also for loop more straight forward)
            array.Swap( pivotIndex, endIndex );
            for( var i = startIndex ; i < endIndex ; i++ )
            {
                if( array[ i ].CompareTo( pivotValue ) > 0 )
                    continue;

                // Value stored to i was smaller than or equal with pivot value - let's move it to start
                array.Swap( i, startIndex );
                // Move start one index forward
                startIndex++;
            }
            // Start index is now pointing to index where we should store our pivot value from end of array
            array.Swap( endIndex, startIndex );
            return startIndex;
        }

        private static void Swap<T>( this T[] array, int index1, int index2 )
        {
            if( index1 == index2 )
                return;

            var temp = array[ index1 ];
            array[ index1 ] = array[ index2 ];
            array[ index2 ] = temp;
        }

        #endregion
    }
}
