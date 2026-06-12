subtype Evens is Integer range 0..Integer'Last with
    Dynamic_Predicate => Evens mod 2 = 0;

type Data is array (Natural range <>) of Integer;
subtype Limits is Data with
    Dynamic_Predicate => (for all I in Limits'First..Limits'Last - 1 => Limits(I) < Limits(I + 1));

type Days is (Mon, Tue, Wed, Thu, Fri, Sat, Sun);
subtype Alternates is Days with
    Static_Predicate => Alternates in Mon | Wed | Fri | Sun;
