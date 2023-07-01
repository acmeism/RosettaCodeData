// ----------------------------------------------------------------------------------------------
//
//  Program.cs - DynamicClassVariable
//
//     Mikko Puonti, 2013
//
// ----------------------------------------------------------------------------------------------

using System;
using System.Dynamic;

namespace DynamicClassVariable
{
    internal static class Program
    {
        #region Static Members

        private static void Main()
        {
            // To enable late binding, we must use dynamic keyword
            // ExpandoObject readily implements IDynamicMetaObjectProvider which allows us to do some dynamic magic
            dynamic sampleObj = new ExpandoObject();
            // Adding a new property
            sampleObj.bar = 1;
            Console.WriteLine( "sampleObj.bar = {0}", sampleObj.bar );

            // We can also add dynamically methods and events to expando object
            // More information: http://msdn.microsoft.com/en-us/library/system.dynamic.expandoobject.aspx
            // This sample only show very small part of dynamic language features - there is lot's more

            Console.WriteLine( "< Press any key >" );
            Console.ReadKey();
        }

        #endregion
    }
}
