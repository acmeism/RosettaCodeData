'''
Create a Decision table then use it
'''

def dt_creator():
    print("\n\nCREATING THE DECISION TABLE\n")
    conditions = input("Input conditions, in order, separated by commas: ")
    conditions = [c.strip() for c in conditions.split(',')]
    print( ("\nThat was %s conditions:\n  " % len(conditions))
           + '\n  '.join("%i: %s" % x for x in enumerate(conditions, 1)) )
    print("\nInput an action, a semicolon, then a list of tuples of rules that trigger it. End with a blank line")
    action2rules, action = [], ' '
    while action:
        action = input("%i: " % (len(action2rules) + 1)).strip()
        if action:
            name, _, rules = [x.strip() for x in action.partition(';')]
            rules = eval(rules)
            assert all(len(rule) == len(conditions) for rule in rules), \
                   "The number of conditions in a rule to trigger this action is wrong"
            action2rules.append((name, rules))
    actions = [x[0] for x in action2rules]
    # Map condition to actions
    rule2actions = dict((y,[]) for y in set(sum((x[1] for x in action2rules), [])))
    for action, rules in action2rules:
        for r in rules:
            rule2actions[r].append( action )
    return conditions, rule2actions

def dt_user(dt, default=['Pray!']):
    conditions, rule2actions = dt
    print("\n\nUSING THE DECISION TABLE\n")
    rule = tuple(int('y' == input("%s? (Answer y if statement is true or n): " % c)) for c in conditions)
    print("Try this:\n  " + '\n  '.join(rule2actions.get(rule, default)))

if __name__ == '__main__':
    dt = dt_creator()
    dt_user(dt)
    dt_user(dt)
    dt_user(dt)
