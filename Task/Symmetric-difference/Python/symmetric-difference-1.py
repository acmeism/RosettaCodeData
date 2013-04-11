>>> setA = {"John", "Bob", "Mary", "Serena"}
>>> setB = {"Jim", "Mary", "John", "Bob"}
>>> setA ^ setB # symmetric difference of A and B
{'Jim', 'Serena'}
>>> setA - setB # elements in A that are not in B
{'Serena'}
>>> setB - setA # elements in B that are not in A
{'Jim'}
>>>
