#include <iostream>
#include <string>
#include <fstream>

class cipher {
public:
    bool work( std::string e, std::string f, std::string k ) {
        if( e.length() < 1 ) return false;
        fileBuffer = readFile( f );
        if( "" == fileBuffer ) return false;
        keyBuffer = readFile( k );
        if( "" == keyBuffer ) return false;

        outName = f;
        outName.insert( outName.find_first_of( "." ), "_out" );

        switch( e[0] ) {
            case 'e': return encode();
            case 'd': return decode();
        }
        return false;
    }
private:
    bool encode() {
        size_t idx, len = keyBuffer.length() >> 1;
        for( std::string::iterator i = fileBuffer.begin(); i != fileBuffer.end(); i++ ) {
            idx = keyBuffer.find_first_of( *i );
            if( idx < len ) outBuffer.append( 1, keyBuffer.at( idx + len ) );
            else outBuffer.append( 1, *i );
        }
        return saveOutput();
    }
    bool decode() {
        size_t idx, l = keyBuffer.length(), len = l >> 1;
        for( std::string::iterator i = fileBuffer.begin(); i != fileBuffer.end(); i++ ) {
            idx = keyBuffer.find_last_of( *i );
            if( idx >= len && idx < l ) outBuffer.append( 1, keyBuffer.at( idx - len ) );
            else outBuffer.append( 1, *i );
        }
        return saveOutput();
    }
    bool saveOutput() {
        std::ofstream o( outName.c_str() );
        o.write( outBuffer.c_str(), outBuffer.size() );
        o.close();
        return true;
    }
    std::string readFile( std::string fl ) {
        std::string buffer = "";
        std::ifstream f( fl.c_str(), std::ios_base::in );
        if( f.good() ) {
            buffer = std::string( ( std::istreambuf_iterator<char>( f ) ), std::istreambuf_iterator<char>() );
            f.close();
        }
        return buffer;
    }
    std::string fileBuffer, keyBuffer, outBuffer, outName;
};

int main( int argc, char* argv[] ) {
    if( argc < 4 ) {
        std::cout << "<d or e>\tDecrypt or Encrypt\n<filename>\tInput file, the output file will have"
        "'_out' added to it.\n<key>\t\tfile with the key to encode/decode\n\n";
    } else {
        cipher c;
        if( c.work( argv[1], argv[2], argv[3] ) ) std::cout << "\nFile successfully saved!\n\n";
        else std::cout << "Something went wrong!\n\n";
    }
    return 0;
}
