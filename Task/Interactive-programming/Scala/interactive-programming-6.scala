scala> def f(str1: String, str2: String, separator: String) =
     | str1 + separator + str2
f: (str1: String,str2: String,separator: String)java.lang.String

scala> f("rosetta", "code", ":")
res3: java.lang.String = rosetta:code

scala> f("code", "rosetta", ", ")
res4: java.lang.String = code, rosetta
