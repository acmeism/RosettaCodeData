? bstr1(1, 2)
# value: [2]

? bstr.replace(0, bstr.size(), bstr2, 1, 3)
? bstr
# value: [2, 3].diverge()
