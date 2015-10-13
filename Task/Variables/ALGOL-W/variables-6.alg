% using the person record defined above...%
    reference (person) someone;
    someone := person           % create a new person structure with uninitialised fields %
    name(someone) := "Fred";    % initialise the fields %
    age(someone)  := 27;
    % could also initialise the fields when the record is created: %
    someone := person( "Harry", 32 );
