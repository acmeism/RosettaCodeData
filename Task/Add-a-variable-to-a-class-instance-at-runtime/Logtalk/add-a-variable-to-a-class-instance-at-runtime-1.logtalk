% we start by defining an empty object
:- object(foo).

    % ensure that complementing categories are allowed
	:- set_logtalk_flag(complements, allow).

:- end_object.

% define a complementing category, adding a new predicate
:- category(bar,
    complements(foo)).

	:- public(bar/1).
	bar(1).
	bar(2).
	bar(3).

:- end_category.
