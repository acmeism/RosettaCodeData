template<class T>
class matrix
{
public:
    matrix( unsigned int nSize ) :
      m_oData(nSize * nSize, 0), m_nSize(nSize) {}

      inline T& operator()(unsigned int x, unsigned int y)
      {
          return m_oData[x+m_nSize*y];
      }

      void identity()
      {
          int nCount = 0;
          int nStride = m_nSize + 1;
          std::generate( m_oData.begin(), m_oData.end(),
              [&]() { return !(nCount++%nStride); } );
      }

      inline unsigned int size() { return m_nSize; }

private:
    std::vector<T>    m_oData;
    unsigned int      m_nSize;
};

int main()
{
    int nSize;
    std::cout << "Enter matrix size (N): ";
    std::cin >> nSize;

    matrix<int> oMatrix( nSize );

    oMatrix.identity();

    for ( unsigned int y = 0; y < oMatrix.size(); y++ )
    {
        for ( unsigned int x = 0; x < oMatrix.size(); x++ )
        {
            std::cout << oMatrix(x,y) << " ";
        }
        std::cout << std::endl;
    }
    return 0;
}
