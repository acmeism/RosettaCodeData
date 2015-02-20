--assume A, B and C to be valid classes
class X
feature -- alias for "feature {ANY}"
-- ANY is the class at the top of the class hierarchy and all classes inherit from it
-- features following this clause are given "global" scope: these features are visible to every class

feature {A, B, C, X}
-- features following this clause are only visible to the specified classes (and their descendants)
-- classes not in this set do not even know of the existence of these features

feature {A, B, C}
-- similar to above, except other instances of X cannot access these features

feature {X}
-- features following this clause are only visible to instances of X (and its descendants)

feature {NONE}
-- NONE is the class at the bottom of the class hierarchy and inherits from every class
-- features following this clause are only visible to this particular instance of X

end
