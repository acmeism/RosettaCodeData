#include <map>

template <typename State, typename Transition = State>
class finite_state_machine
{
protected:
	State
		current;
	std::map<State, std::map<Transition, State>>
		database;
public:
	finite_state_machine()
	{	
		set(State());
	}
	void
		set(State const& state)
	{
		current = state;
	}
	State
		get() const
	{
		return current;
	}
	void
		clear()
	{
		database.clear();
	}
	void
		add(State const& state, Transition const& transition, State const& next)
	{
		database[state][transition] = next;
	}	
/*
	Add a state which is also it's own transition (and thus a link in a chain of sequences)
*/	
	void
		add(State const& state_and_transition, State const& next)
	{
		add(state_and_transition, state_and_transition, next);
	}
	bool
		process(Transition const& transition)
	{
		auto const&
			transitions = database[current],
			found = transitions.find(transition);
		if(found == transitions.end())
			return false;
		auto const&
			next = found->second;
		set(next);
		return true;
	}
/*
	Process so-called "automatic transitions" (ie: sequencing)
*/
	bool
		process()
	{
		return process(get());
	}
/*
	A set of utility functions that may be helpful for displaying valid transitions to the user, etc...
*/	
	template <typename PushBackContainer>
	bool
		get_valid_transitions(State const& state, PushBackContainer& container)
	{
		container.clear();
		auto const&
			found = database.find(state);
		if(found == database.end())
			return false;
		auto const&
			transitions = found->second;
		if(transitions.size() == 0)
			return false;
		for(auto const& iterator : transitions)
		{
			auto const&
				transition = iterator.first;
			container.push_back(transition);
		}
		return true;
	}
	template <typename Container>
	bool
		get_valid_transitions(Container& container)
	{
		return get_valid_transitions(get(), container);
	}
};

/*
	Example usage: a simple vending machine
*/

#include <string>
#include <vector>
#include <iostream>

using namespace
	std;
void
	print(string const& message)
{
	cout << message << endl;
}
int
	main()
{
	finite_state_machine<string>
		machine;
	machine.add("ready", "quit", "exit");
	machine.add("ready", "deposit", "waiting");
	machine.add("waiting", "select", "dispense");
	machine.add("waiting", "refund", "refunding");
	machine.add("dispense", "remove", "ready");
	machine.add("refunding", "ready");
	machine.set("ready");
	for(;;)
	{
		string
			state = machine.get();
		if(state == "ready")
			print("Please deposit coins.");
		else if(state == "waiting")
			print("Please select a product.");
		else if(state == "dispense")
			print("Dispensed...please remove product from tray.");
		else if(state == "refunding")
			print("Refunding money...");	
		else if(state == "exit")
			break;
		else
			print("Internal error: unaccounted state '" + state + "'!");
	/*
		Handle "automatic" transitions
	*/
		if(machine.process())
			continue;
		vector<string>
			transitions;
		machine.get_valid_transitions(transitions);
		string
			options;
		for(auto const& transition : transitions)
		{
			if(!options.empty())
				options += ", ";
			options += transition;
		}
		print("[" + state + "] Input the next transition (" + options + "): ");
		string
			transition;
		cout << " > ";
		cin >> transition;
		if(!machine.process(transition))
			print( "Error: invalid transition!");	
	}
}
