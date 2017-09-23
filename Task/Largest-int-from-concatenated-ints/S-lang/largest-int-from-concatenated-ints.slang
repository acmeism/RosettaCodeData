define catcmp(a, b)
{
   a = string(a);
   b = string(b);
   return strcmp(b+a, a+b);
}
	
define maxcat(arr)
{
   arr = arr[array_sort(arr, &catcmp)];
   variable result = "", elem;
   foreach elem (arr)
     result += string(elem);
   return result;
}

print("max of series 1 is " + maxcat([1, 34, 3, 98, 9, 76, 45, 4]));
print("max of series 2 is " + maxcat([54, 546, 548, 60]));
