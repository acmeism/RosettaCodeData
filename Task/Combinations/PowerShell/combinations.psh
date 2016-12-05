$source = @'
    using System;
    using System.Collections.Generic;

    namespace Powershell
    {
        public class CSharp
        {
            public static IEnumerable<int[]> Combinations(int m, int n)
            {
                int[] result = new int[m];
                Stack<int> stack = new Stack<int>();
                stack.Push(0);

                while (stack.Count > 0) {
                    int index = stack.Count - 1;
                    int value = stack.Pop();

                    while (value < n) {
                        result[index++] = value++;
                        stack.Push(value);
                        if (index == m) {
                            yield return result;
                            break;
                        }
                    }
                }
            }
        }
    }
'@

Add-Type -TypeDefinition $source -Language CSharp

[Powershell.CSharp]::Combinations(3,5) | Format-Wide {$_} -Column 3 -Force
