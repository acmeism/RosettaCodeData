Python 3.2 (r32:88445, Feb 20 2011, 21:30:00) [MSC v.1500 64 bit (AMD64)] on win 32
Type "help", "copyright", "credits" or "license" for more information.
>>> from concurrent import futures
>>> with futures.ProcessPoolExecutor() as executor:
...   _ = list(executor.map(print, 'Enjoy Rosetta Code'.split()))
...
Enjoy
Rosetta
Code
>>>
