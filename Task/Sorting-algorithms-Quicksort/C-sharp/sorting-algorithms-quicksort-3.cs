using System;
using System.Collections.Generic;
using System.Linq;

namespace QSort
{
    class QSorter
    {
        private static IEnumerable<IComparable> empty = new List<IComparable>();

        public static IEnumerable<IComparable> QSort(IEnumerable<IComparable> iEnumerable)
        {
            if(iEnumerable.Any())
            {
                var pivot = iEnumerable.First();
                return QSort(iEnumerable.Where((anItem) => pivot.CompareTo(anItem) > 0)).
                    Concat(iEnumerable.Where((anItem) => pivot.CompareTo(anItem) == 0)).
                    Concat(QSort(iEnumerable.Where((anItem) => pivot.CompareTo(anItem) < 0)));
            }
            return empty;
        }
    }
}
