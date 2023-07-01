assert 'apples, pears' == stripComments('apples, pears # and bananas')
assert 'apples, pears' == stripComments('apples, pears ; and bananas')
