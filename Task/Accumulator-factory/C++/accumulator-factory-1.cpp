#include <iostream>

class Acc
{
public:
    Acc(int init)
        : _type(intType)
        , _intVal(init)
    {}

    Acc(float init)
        : _type(floatType)
        , _floatVal(init)
    {}

    int operator()(int x)
    {
        if( _type == intType )
        {
            _intVal += x;
            return _intVal;
        }
        else
        {
            _floatVal += x;
            return static_cast<int>(_floatVal);
        }
    }

    float operator()(float x)
    {
        if( _type == intType )
        {
            _floatVal = _intVal + x;
            _type = floatType;
            return _floatVal;
        }
        else
        {
            _floatVal += x;
            return _floatVal;
        }
    }
private:
    enum {floatType, intType} _type;
    float _floatVal;
    int _intVal;
};

int main()
{
    Acc a(1);
    a(5);
    Acc(3);
    std::cout << a(2.3f);
    return 0;
}
