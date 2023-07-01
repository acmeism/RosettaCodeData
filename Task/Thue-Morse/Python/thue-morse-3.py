>>> def thue_morse_subs(chars):
...     ans = '0'
...     while len(ans) < chars:
...         ans = ans.replace('0', '0_').replace('1', '10').replace('_', '1')
...     return ans[:chars]
...
>>> thue_morse_subs(20)
'01101001100101101001'
>>>
