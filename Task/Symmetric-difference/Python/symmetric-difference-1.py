>>> setA = {"John", "Bob", "Mary", "Serena"}
>>> setB = {"Jim", "Mary", "John", "Bob"}
>>> setA ^ setB # symmetric difference of A and B
{'Jim', 'Serena'}
>>> setA - setB # elements in A that are not in B
{'Serena'}
>>> setB - setA # elements in B that are not in A
{'Jim'}
>>> setA | setB # elements in A or B (union)
{'John', 'Bob', 'Jim', 'Serena', 'Mary'}
>>> setA & setB # elements in both A and B (intersection)
{'Bob', 'John', 'Mary'}
