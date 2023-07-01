#include <complex>
#include <math.h>
#include <iostream>

template<class Type>
struct Precision
{
public:
	static Type GetEps()
	{
		return eps;
	}

	static void SetEps(Type e)
	{
		eps = e;
	}

private:
	static Type eps;
};

template<class Type> Type Precision<Type>::eps = static_cast<Type>(1E-7);

template<class DigType>
bool IsDoubleEqual(DigType d1, DigType d2)
{
	return (fabs(d1 - d2) < Precision<DigType>::GetEps());
}

template<class DigType>
DigType IntegerPart(DigType value)
{
	return (value > 0) ? floor(value) : ceil(value);
}

template<class DigType>
DigType FractionPart(DigType value)
{
	return fabs(IntegerPart<DigType>(value) - value);
}

template<class Type>
bool IsInteger(const Type& value)
{
	return false;
}

#define GEN_CHECK_INTEGER(type)			\
template<>					\
bool IsInteger<type>(const type& value)         \
{						\
	return true;				\
}

#define GEN_CHECK_CMPL_INTEGER(type)					\
template<>								\
bool IsInteger<std::complex<type> >(const std::complex<type>& value)	\
{									\
	type zero = type();						\
	return value.imag() == zero;					\
}

#define GEN_CHECK_REAL(type)						\
template<>								\
bool IsInteger<type>(const type& value)					\
{									\
	type zero = type();						\
	return IsDoubleEqual<type>(FractionPart<type>(value), zero);	\
}

#define GEN_CHECK_CMPL_REAL(type)					\
template<>								\
bool IsInteger<std::complex<type> >(const std::complex<type>& value)	\
{									\
	type zero = type();						\
	return IsDoubleEqual<type>(value.imag(), zero);			\
}

#define GEN_INTEGER(type)		\
	GEN_CHECK_INTEGER(type)		\
	GEN_CHECK_CMPL_INTEGER(type)

#define GEN_REAL(type)			\
	GEN_CHECK_REAL(type)		\
	GEN_CHECK_CMPL_REAL(type)


GEN_INTEGER(char)
GEN_INTEGER(unsigned char)
GEN_INTEGER(short)
GEN_INTEGER(unsigned short)
GEN_INTEGER(int)
GEN_INTEGER(unsigned int)
GEN_INTEGER(long)
GEN_INTEGER(unsigned long)
GEN_INTEGER(long long)
GEN_INTEGER(unsigned long long)

GEN_REAL(float)
GEN_REAL(double)
GEN_REAL(long double)

template<class Type>
inline void TestValue(const Type& value)
{
	std::cout << "Value: " << value << " of type: " << typeid(Type).name() << " is integer - " << std::boolalpha << IsInteger(value) << std::endl;
}

int main()
{
	char c = -100;
	unsigned char uc = 200;
	short s = c;
	unsigned short us = uc;
	int i = s;
	unsigned int ui = us;
	long long ll = i;
	unsigned long long ull = ui;

	std::complex<unsigned int> ci1(2, 0);
	std::complex<int> ci2(2, 4);
	std::complex<int> ci3(-2, 4);
	std::complex<unsigned short> cs1(2, 0);
	std::complex<short> cs2(2, 4);
	std::complex<short> cs3(-2, 4);

	std::complex<double> cd1(2, 0);
	std::complex<float> cf1(2, 4);
	std::complex<double> cd2(-2, 4);

	float f1 = 1.0;
	float f2 = -2.0;
	float f3 = -2.4f;
	float f4 = 1.23e-5f;
	float f5 = 1.23e-10f;
	double d1 = f5;

	TestValue(c);
	TestValue(uc);
	TestValue(s);
	TestValue(us);
	TestValue(i);
	TestValue(ui);
	TestValue(ll);
	TestValue(ull);

	TestValue(ci1);
	TestValue(ci2);
	TestValue(ci3);
	TestValue(cs1);
	TestValue(cs2);
	TestValue(cs3);

	TestValue(cd1);
	TestValue(cd2);
	TestValue(cf1);

	TestValue(f1);
	TestValue(f2);
	TestValue(f3);
	TestValue(f4);
	TestValue(f5);
	std::cout << "Set float precision: 1e-15f\n";
	Precision<float>::SetEps(1e-15f);
	TestValue(f5);
	TestValue(d1);
	return 0;
}
