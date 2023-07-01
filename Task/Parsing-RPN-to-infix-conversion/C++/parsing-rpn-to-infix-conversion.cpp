#include <iostream>
#include <stack>
#include <string>
#include <map>
#include <set>

using namespace std;

struct Entry_
{
	string expr_;
	string op_;
};

bool PrecedenceLess(const string& lhs, const string& rhs, bool assoc)
{
	static const map<string, int> KNOWN({ { "+", 1 }, { "-", 1 }, { "*", 2 }, { "/", 2 }, { "^", 3 } });
	static const set<string> ASSOCIATIVE({ "+", "*" });
	return (KNOWN.count(lhs) ? KNOWN.find(lhs)->second : 0) < (KNOWN.count(rhs) ? KNOWN.find(rhs)->second : 0) + (assoc && !ASSOCIATIVE.count(rhs) ? 1 : 0);
}
void Parenthesize(Entry_* old, const string& token, bool assoc)
{
	if (!old->op_.empty() && PrecedenceLess(old->op_, token, assoc))
		old->expr_ = '(' + old->expr_ + ')';
}

void AddToken(stack<Entry_>* stack, const string& token)
{
	if (token.find_first_of("0123456789") != string::npos)
		stack->push(Entry_({ token, string() }));	// it's a number, no operator
	else
	{	// it's an operator
		if (stack->size() < 2)
			cout<<"Stack underflow";
		auto rhs = stack->top();
		Parenthesize(&rhs, token, false);
		stack->pop();
		auto lhs = stack->top();
		Parenthesize(&lhs, token, true);
		stack->top().expr_ = lhs.expr_ + ' ' + token + ' ' + rhs.expr_;
		stack->top().op_ = token;
	}
}


string ToInfix(const string& src)
{
	stack<Entry_> stack;
	for (auto start = src.begin(), p = src.begin(); ; ++p)
	{
		if (p == src.end() || *p == ' ')
		{
			if (p > start)
				AddToken(&stack, string(start, p));
			if (p == src.end())
				break;
			start = p + 1;
		}
	}
	if (stack.size() != 1)
		cout<<"Incomplete expression";
	return stack.top().expr_;
}

int main(void)
{
	try
	{
		cout << ToInfix("3 4 2 * 1 5 - 2 3 ^ ^ / +") << "\n";
		cout << ToInfix("1 2 + 3 4 + ^ 5 6 + ^") << "\n";
		return 0;
	}
	catch (...)
	{
		cout << "Failed\n";
		return -1;
	}
}
