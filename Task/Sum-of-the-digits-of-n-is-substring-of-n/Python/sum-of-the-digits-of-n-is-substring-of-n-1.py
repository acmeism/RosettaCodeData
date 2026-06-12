Python 3.9.0 (tags/v3.9.0:9cf6752, Oct  5 2020, 15:34:40) [MSC v.1927 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license()" for more information.
>>> x = [n for n in range(1000) if str(sum(int(d) for d in str(n))) in str(n)]
>>> len(x)
48
>>> for i in range(0, len(x), (stride:= 10)): print(str(x[i:i+stride])[1:-1])

0, 1, 2, 3, 4, 5, 6, 7, 8, 9
10, 20, 30, 40, 50, 60, 70, 80, 90, 100
109, 119, 129, 139, 149, 159, 169, 179, 189, 199
200, 300, 400, 500, 600, 700, 800, 900, 910, 911
912, 913, 914, 915, 916, 917, 918, 919
>>>
