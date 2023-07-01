def toRoman(n):
    res=''		#converts int to str(Roman numeral)
    reg=n		#using the numerals (M,D,C,L,X,V,I)
    if reg<4000:#no more than three repetitions
        while reg>=1000:	#thousands up to MMM
            res+='M'		#MAX is MMMCMXCIX
            reg-=1000		
        if reg>=900:		#nine hundreds in 900-999
            res+='CM'
            reg-=900
        if reg>=500:		#five hudreds in 500-899
            res+='D'
            reg-=500
        if reg>=400:		#four hundreds in 400-499
            res+='CD'
            reg-=400
        while reg>=100:		#hundreds in 100-399
            res+='C'
            reg-=100
        if reg>=90:			#nine tens in 90-99
            res+='XC'
            reg-=90
        if reg>=50:			#five Tens in 50-89
            res+='L'
            reg-=50
        if reg>=40:
            res+='XL'		#four Tens
            reg-=40
        while reg>=10:
            res+="X"		#tens
            reg-=10
        if reg>=9:
            res+='IX'		#nine Units
            reg-=9
        if reg>=5:
            res+='V'		#five Units
            reg-=5
        if reg>=4:
            res+='IV'		#four Units
            reg-=4
        while reg>0:		#three or less Units
            res+='I'
            reg-=1
    return res
