roman_values = (('I',1), ('IV',4), ('V',5), ('IX',9),('X',10),('XL',40),('L',50),('XC',90),('C',100),
                    ('CD', 400), ('D', 500), ('CM', 900), ('M',1000))

def roman_value(roman):
    total=0
    for symbol,value in reversed(roman_values):
        while roman.startswith(symbol):
            total += value
            roman = roman[len(symbol):]
    return total

if __name__=='__main__':
    for value in "MCMXC", "MMVIII", "MDCLXVI":
        print('%s = %i' % (value, roman_value(value)))

""" Output:
MCMXC = 1990
MMVIII = 2008
MDCLXVI = 1666
"""
