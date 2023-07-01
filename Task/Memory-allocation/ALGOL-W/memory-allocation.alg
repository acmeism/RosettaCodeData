begin
    % define a record structure - instances must be created dynamically %
    record Element ( integer atomicNumber; string(16) name );
    reference(Element) X;
    % allocate and initialise memory for X - heap storage is the only option %
    X := Element( 1, "Hydrogen" );
    % allocate new memory for X, the original could now be garbage collected %
    X := Element( 2, "Helium" )
    % the memory allocated will now be garbage collected - there is no explicit de-allocation %
end.
