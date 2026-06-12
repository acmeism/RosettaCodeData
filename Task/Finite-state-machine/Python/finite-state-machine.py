''' Finite State Machine for Rosetta Code
Actually two of them.  The main FSM described in the task and a second one of the Acceptor variety described on
the WP page to get the input from the user.

I handled the implicit transition by defining a null list as the valid inputs. and made my Acceptor return the
null string ('') for the instance of no valid inputs.  Then just defined the the transition for current state and null
string for input.

I find it interesting that the rules for such a simple fsm took more lines of code than the actual code for the fsm which
can be fed many different sets of rules.  Storing the rules in a databse would reduce the lines required for storing
the rules'''

states = {  'ready':{
                'prompt' : 'Machine ready: (d)eposit, or (q)uit?',
                'responses' : ['d','q']},
            'waiting':{
                'prompt' : 'Machine waiting: (s)elect, or (r)efund?',
                'responses' : ['s','r']},
            'dispense' : {
                'prompt' : 'Machine dispensing: please (r)emove product',
                'responses' : ['r']},
            'refunding' : {
                'prompt' : 'Refunding money',
                'responses' : []},
            'exit' :{}
          }
transitions = { 'ready': {
                    'd': 'waiting',
                    'q': 'exit'},
                'waiting' : {
                    's' : 'dispense',
                    'r' : 'refunding'},
                'dispense' : {
                    'r' : 'ready'},
                'refunding' : {
                    '' : 'ready'}}

def Acceptor(prompt, valids):
    ''' Acceptor style finite state machine to prompt for user input'''
    if not valids:
        print(prompt)
        return ''
    else:
        while True:
            resp = input(prompt)[0].lower()
            if resp in valids:
                return resp

def finite_state_machine(initial_state, exit_state):
    response = True
    next_state = initial_state
    current_state = states[next_state]
    while response != exit_state:
        response = Acceptor(current_state['prompt'], current_state['responses'])
        next_state = transitions[next_state][response]
        current_state = states[next_state]

if __name__ == "__main__":
    finite_state_machine('ready','q')
