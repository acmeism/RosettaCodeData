class cipherI {
public:
    std::string encode( std::string txt ) {
        txt = b.encode( txt );
        std::string e, d = "one morning, when gregor samsa woke from troubled dreams, he found himself transformed "
        "in his bed into a horrible vermin. he lay on his armour-like back, and if he lifted his head a little he "
        "could see his brown belly, slightly domed and divided by arches into stiff sections.";
        size_t r = 0;
        char t;
        for( std::string::iterator i = txt.begin(); i != txt.end(); i++ ) {
            t = d.at( r );
            while( t < 'a' || t > 'z' ) {
                e.append( 1, t );
                r++;
                t = d.at( r );
            }
            r++;
            e.append( 1, *i == '1' ? t - 32 : t );
        }

        return e;
    }

    std::string decode( std::string txt ) {
        std::string h;
        for( std::string::iterator i = txt.begin(); i != txt.end(); i++ ) {
            if( *i < 'a' && ( *i < 'A' || *i > 'Z' ) || *i > 'z' ) continue;
            h.append( 1, *i & 32 ? '0' : '1' );
        }
        return b.decode( h );
    }

private:
    bacon b;
};

class cipherII {
public:
    std::string encode( std::string txt ) {
        txt = b.encode( txt );
        std::string e;
        for( std::string::iterator i = txt.begin(); i != txt.end(); i++ )
            e.append( 1, *i == '0' ? 0xf9 : 0xfa );
        return e;
    }

    std::string decode( std::string txt ) {
        std::string h;
        for( std::string::iterator i = txt.begin(); i != txt.end(); i++ ) {
            h.append( 1, *i == ( char )0xf9 ? '0' : '1' );
        }
        return b.decode( h );
    }

private:
    bacon b;
};

int main( int argc, char* argv[] ) {
    cipherI c1;
    cipherII c2;
    std::string s = "lets have some fun with bacon cipher";

    std::string h1 = c1.encode( s ),
                h2 = c2.encode( s );

    std::cout << h1 << std::endl << std::endl << c1.decode( h1 ) << std::endl << std::endl;
    std::cout << h2 << std::endl << std::endl << c2.decode( h2 ) << std::endl << std::endl;

    return 0;
}
