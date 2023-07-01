#include <iostream>
#include <iterator>
#include <string>
#include <utility>
#include <vector>

namespace detail {

template <typename ForwardIterator>
class tokenizer
{
	
	ForwardIterator _tbegin, _tend, _end;
	
public:
	
	tokenizer(ForwardIterator begin, ForwardIterator end)
		: _tbegin(begin), _tend(begin), _end(end)
	{ }
	
	template <typename Lambda>
	bool next(Lambda istoken)
	{
		if (_tbegin == _end) {
			return false;
		}
		_tbegin = _tend;
		for (; _tend != _end && !istoken(*_tend); ++_tend) {
			if (*_tend == '\\' && std::next(_tend) != _end) {
				++_tend;
			}
		}
		if (_tend == _tbegin) {
			_tend++;
		}
		return _tbegin != _end;
	}
	
	ForwardIterator begin() const { return _tbegin; }
	ForwardIterator end()   const { return _tend; }
	bool operator==(char c) { return *_tbegin == c; }
	
};

template <typename List>
void append_all(List & lista, const List & listb)
{
	if (listb.size() == 1) {
		for (auto & a : lista) {
			a += listb.back();
		}
	} else {
		List tmp;
		for (auto & a : lista) {
			for (auto & b : listb) {
				tmp.push_back(a + b);
			}
		}
		lista = std::move(tmp);
	}
}

template <typename String, typename List, typename Tokenizer>
List expand(Tokenizer & token)
{
	
	std::vector<List> alts{ { String() } };
	
	while (token.next([](char c) { return c == '{' || c == ',' || c == '}'; })) {
		
		if (token == '{') {
			append_all(alts.back(), expand<String, List>(token));
		} else if (token == ',') {
			alts.push_back({ String() });
		} else if (token == '}') {
			if (alts.size() == 1) {
				for (auto & a : alts.back()) {
					a = '{' + a + '}';
				}
				return alts.back();
			} else {
				for (std::size_t i = 1; i < alts.size(); i++) {
					alts.front().insert(alts.front().end(),
						std::make_move_iterator(std::begin(alts[i])),
						std::make_move_iterator(std::end(alts[i])));
				}
				return std::move(alts.front());
			}
		} else {
			for (auto & a : alts.back()) {
				a.append(token.begin(), token.end());
			}
		}
		
	}
	
	List result{ String{ '{' } };
	append_all(result, alts.front());
	for (std::size_t i = 1; i < alts.size(); i++) {
		for (auto & a : result) {
			a += ',';
		}
		append_all(result, alts[i]);
	}
	return result;
}

} // namespace detail

template <
	typename ForwardIterator,
	typename String = std::basic_string<
		typename std::iterator_traits<ForwardIterator>::value_type
	>,
	typename List = std::vector<String>
>
List expand(ForwardIterator begin, ForwardIterator end)
{
	detail::tokenizer<ForwardIterator> token(begin, end);
	List list{ String() };
	while (token.next([](char c) { return c == '{'; })) {
		if (token == '{') {
			detail::append_all(list, detail::expand<String, List>(token));
		} else {
			for (auto & a : list) {
				a.append(token.begin(), token.end());
			}
		}
	}
	return list;
}

template <
	typename Range,
	typename String = std::basic_string<typename Range::value_type>,
	typename List = std::vector<String>
>
List expand(const Range & range)
{
	using Iterator = typename Range::const_iterator;
	return expand<Iterator, String, List>(std::begin(range), std::end(range));
}

int main()
{
	
	for (std::string string : {
		R"(~/{Downloads,Pictures}/*.{jpg,gif,png})",
		R"(It{{em,alic}iz,erat}e{d,}, please.)",
		R"({,{,gotta have{ ,\, again\, }}more }cowbell!)",
		R"({}} some {\\{edge,edgy} }{ cases, here\\\})",
		R"(a{b{1,2}c)",
		R"(a{1,2}b}c)",
		R"(a{1,{2},3}b)",
		R"(a{b{1,2}c{}})",
		R"(more{ darn{ cowbell,},})",
		R"(ab{c,d\,e{f,g\h},i\,j{k,l\,m}n,o\,p}qr)",
		R"({a,{\,b}c)",
		R"(a{b,{{c}})",
		R"({a{\}b,c}d)",
		R"({a,b{{1,2}e}f)",
		R"({}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\})",
		R"({{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{)",
	}) {
		std::cout << string << '\n';
		for (auto expansion : expand(string)) {
			std::cout << "    " << expansion << '\n';
		}
		std::cout << '\n';
	}
	
	return 0;
}
