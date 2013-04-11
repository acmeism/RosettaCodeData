def multiLineString = '''
A man
A plan
A canal
'''

def multiLineGString = """
${multiLineString.trim()}:
Panama!
"""

println multiLineGString

//Outputs:
//
//A man
//A plan
//A canal:
//Panama!
//
