import os,sys,zlib,urllib.request

def h ( str,x=9 ):
    for c in str :
        x = ( x*33 + ord( c )) & 0xffffffffff
    return x

def cache ( func,*param ):
    n = 'cache_%x.bin'%abs( h( repr( param )))
    try    : return eval( zlib.decompress( open( n,'rb' ).read()))
    except : pass
    s = func( *param )
    open( n,'wb' ).write( zlib.compress( bytes( repr( s ),'ascii' )))
    return s

dico_url  = 'https://raw.githubusercontent.com/quinnj/Rosetta-Julia/master/unixdict.txt'
read_url  = lambda url   : urllib.request.urlopen( url ).read()
load_dico = lambda url   : tuple( cache( read_url,url ).split( b'\n'))
isnext    = lambda w1,w2 : len( w1 ) == len( w2 ) and len( list( filter( lambda l : l[0]!=l[1] , zip( w1,w2 )))) == 1

def build_map ( words ):
    map = [(w.decode('ascii'),[]) for w in words]
    for i1,(w1,n1) in enumerate( map ):
        for i2,(w2,n2) in enumerate( map[i1+1:],i1+1 ):
            if isnext( w1,w2 ):
                n1.append( i2 )
                n2.append( i1 )
    return map

def find_path ( words,w1,w2 ):
    i = [w[0] for w in words].index( w1 )
    front,done,res  = [i],{i:-1},[]
    while front :
        i = front.pop(0)
        word,next = words[i]
        for n in next :
            if n in done : continue
            done[n] = i
            if words[n][0] == w2 :
                while n >= 0 :
                    res = [words[n][0]] + res
                    n = done[n]
                return ' '.join( res )
            front.append( n )
    return '%s can not be turned into %s'%( w1,w2 )

for w in ('boy man','girl lady','john jane','alien drool','child adult'):
    print( find_path( cache( build_map,load_dico( dico_url )),*w.split()))
