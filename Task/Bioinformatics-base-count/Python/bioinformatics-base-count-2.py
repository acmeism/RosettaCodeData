"""
	Python 3.10.5 (main, Jun  6 2022, 18:49:26) [GCC 12.1.0] on linux

	Created on Wed 2022/08/17 11:19:31
	
"""


def main ():

	def DispCount () :

	    return f'\n\nBases :\n\n' + f''.join ( [ f'{i} =\t{D [ i ]:4d}\n' for i in  sorted ( BoI ) ] )


	S =	'CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG' \
		'AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT' \
		'CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA' \
		'TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTATCGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG' \
		'TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGACGACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT'

	All   = set( S )
	
	BoI   = set ( [ "A","C","G","T" ] )
	
	other = All - BoI
	
	D     = { k : S.count ( k ) for k in All }
	
	print ( 'Sequence:\n\n')

	print ( ''.join ( [ f'{k:4d} : {S [ k: k + 50 ]}\n' for k in range ( 0, len ( S ), 50 ) ] ) )

	print ( f'{DispCount ()} \n------------')

	print ( '' if ( other == set () ) else f'Other\t{sum ( [ D [ k ] for k in sorted ( other ) ] ):4d}\n\n' )

	print ( f'Σ = \t {sum ( [ D [ k ] for k in sorted ( All ) ] ) } \n============\n')
	
	pass


def test ():

	pass


## START

LIVE = True

if ( __name__ == '__main__' ) :

	main () if LIVE else test ()
