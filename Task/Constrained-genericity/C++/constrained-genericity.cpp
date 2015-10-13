template<typename T> //Detection helper struct
struct can_eat       //Detects presence of non-const member function void eat()
{
  private:
    template<typename U, void (U::*)()> struct SFINAE {};
    template<typename U> static char Test(SFINAE<U, &U::eat>*);
    template<typename U> static int Test(...);
  public:
    static constexpr bool value = sizeof(Test<T>(0)) == sizeof(char);
};

struct potato
{ void eat(); };

struct brick
{};

template<typename T>
class FoodBox
{
    //Using static assertion to prohibit non-edible types
    static_assert(can_eat<T>::value, "Only edible items are allowed in foodbox");

    //Rest of class definition
};

int main()
{
    FoodBox<potato> lunch;

    //Following leads to compile-time error
    //FoodBox<brick> practical_joke;
}
