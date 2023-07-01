#include <iostream>    // compiled with clang (tags/RELEASE_600/final)
#include <type_traits> // or g++ (GCC) 7.3.1 20180406 -- from hare1039
namespace functional_list // basic building block for template meta programming
{
struct NIL
{
	using head = NIL;
	using tail = NIL;
	friend std::ostream& operator << (std::ostream& os, NIL const) { return os; }
};

template <typename H, typename T = NIL>
struct list
{
	using head = H;
	using tail = T;
};

template <int i>
struct integer
{
	static constexpr int value = i;
	friend std::ostream& operator << (std::ostream& os, integer<i> const) { os << integer<i>::value; return os;}
};

template <typename L, int nTH> constexpr
auto at()
{
	if constexpr (nTH == 0)
		return (typename L::head){};
	else if constexpr (not std::is_same_v<typename L::tail, NIL>)
		return at<typename L::tail, nTH - 1>();
	else
		return NIL{};
}
template <typename L, int nTH>
using at_t = decltype(at<L, nTH>());

template <typename L, typename elem> constexpr
auto prepend() { return list<elem, L>{}; }

template <typename L, typename elem>
using prepend_t = decltype(prepend<L, elem>());
	
template <int Size, typename Dat = integer<0>> constexpr
auto gen_list()
{
	if constexpr (Size == 0)
		return NIL{};
	else
	{
		using next = decltype(gen_list<Size - 1, Dat>());
		return prepend<next, Dat>();
	}
}
template <int Size, typename Dat = integer<0>>
using gen_list_t = decltype(gen_list<Size, Dat>());
	
} namespace fl = functional_list;

constexpr int door_amount = 101; // index from 1 to 100

template <typename L, int current, int moder> constexpr
auto construct_loop()
{
	using val_t = fl::at_t<L, current>;
	if constexpr (std::is_same_v<val_t, fl::NIL>)
		return fl::NIL{};
	else
	{
		constexpr int val = val_t::value;
		using val_add_t = fl::integer<val + 1>;
		using val_old_t = fl::integer<val>;
	
		if constexpr (current == door_amount)
		{
			if constexpr(current % moder == 0)
				return fl::list<val_add_t>{};
			else
				return fl::list<val_old_t>{};
		}
		else
		{
			using sub_list = decltype(construct_loop<L, current + 1, moder>());
			if constexpr(current % moder == 0)
				return fl::prepend<sub_list, val_add_t>();
			else
				return fl::prepend<sub_list, val_old_t>();
		}
	}
}

template <int iteration> constexpr
auto construct()
{
	if constexpr (iteration == 1) // door index = 1
	{
		using l = fl::gen_list_t<door_amount>;
		return construct_loop<l, 0, iteration>();
	}
	else
	{
		using prev_iter_list = decltype(construct<iteration - 1>());
		return construct_loop<prev_iter_list, 0, iteration>();
	}
}

template <typename L, int pos> constexpr
void show_ans()
{
	if constexpr (std::is_same_v<typename L::head, fl::NIL>)
		return;
	else
	{
		if constexpr (L::head::value % 2 == 1)
			std::cout << "Door " << pos << " is opened.\n";
		show_ans<typename L::tail, pos + 1>();
	}
}

int main()
{
	using result = decltype(construct<100>());
	show_ans<result, 0>();
}
