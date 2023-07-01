#include <map>
#include <vector>
#include <iostream>
#include <fstream>
#include <utility>
#include <functional>
#include <string>
#include <sstream>
#include <algorithm>
#include <cctype>

class CSV
{
public:
    CSV(void) : m_nCols( 0 ), m_nRows( 0 )
    {}

    bool open( const char* filename, char delim = ',' )
    {
        std::ifstream file( filename );

        clear();
        if ( file.is_open() )
        {
            open( file, delim );
            return true;
        }

        return false;
    }

    void open( std::istream& istream, char delim = ',' )
    {
        std::string         line;

        clear();
        while ( std::getline( istream, line ) )
        {
            unsigned int nCol = 0;
            std::istringstream    lineStream(line);
            std::string           cell;

            while( std::getline( lineStream, cell, delim ) )
            {
                m_oData[std::make_pair( nCol, m_nRows )] = trim( cell );
                nCol++;
            }
            m_nCols = std::max( m_nCols, nCol );
            m_nRows++;
        }
    }

    bool save( const char* pFile, char delim = ',' )
    {
        std::ofstream ofile( pFile );
        if ( ofile.is_open() )
        {
            save( ofile );
            return true;
        }
        return false;
    }

    void save( std::ostream& ostream, char delim = ',' )
    {
        for ( unsigned int nRow = 0; nRow < m_nRows; nRow++ )
        {
            for ( unsigned int nCol = 0; nCol < m_nCols; nCol++ )
            {
                ostream << trim( m_oData[std::make_pair( nCol, nRow )] );
                if ( (nCol+1) < m_nCols )
                {
                    ostream << delim;
                }
                else
                {
                    ostream << std::endl;
                }
            }
        }
    }

    void clear()
    {
        m_oData.clear();
        m_nRows = m_nCols = 0;
    }

    std::string& operator()( unsigned int nCol, unsigned int nRow )
    {
        m_nCols = std::max( m_nCols, nCol+1 );
        m_nRows = std::max( m_nRows, nRow+1 );
        return m_oData[std::make_pair(nCol, nRow)];
    }

    inline unsigned int GetRows() { return m_nRows; }
    inline unsigned int GetCols() { return m_nCols; }

private:
    // trim string for empty spaces in begining and at the end
    inline std::string &trim(std::string &s)
    {

        s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
        s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
        return s;
    }

private:
    std::map<std::pair<unsigned int, unsigned int>, std::string> m_oData;

    unsigned int    m_nCols;
    unsigned int    m_nRows;
};


int main()
{
    CSV oCSV;

    oCSV.open( "test_in.csv" );
    oCSV( 0, 0 ) = "Column0";
    oCSV( 1, 1 ) = "100";
    oCSV( 2, 2 ) = "200";
    oCSV( 3, 3 ) = "300";
    oCSV( 4, 4 ) = "400";
    oCSV.save( "test_out.csv" );
    return 0;
}
