:- module(json_pointer, [json_pointer/3]).
:- use_module(library(http/json), [atom_json_term/3]).

%!  json_pointer(+Pointer, +JSON0, -JSON) is semidet.
%   Fails if the pointer is invalid.
json_pointer(Pointer, JSON0, JSON) :-
    once(phrase(json_pointer(JSON0, JSON), Pointer)).

json_pointer(JSON, JSON) --> [].
json_pointer(JSON0, JSON) -->
    "/", property_name(Key),
    { json_get_key(Key, JSON0, JSON1) },
    json_pointer(JSON1, JSON).

property_name([0'/ | Cs]) --> "~1", property_name(Cs).
property_name([0'~ | Cs]) --> "~0", property_name(Cs).
property_name([C   | Cs]) --> [C], { C \= 0'/, C \= 0'~ }, property_name(Cs).
property_name([])         --> [].

json_get_key(Name, json(KeyVals), JSON) :-
    !,
    atom_codes(Key, Name),
    memberchk(Key=JSON, KeyVals).

json_get_key(Number, JSON0, JSON) :-
    is_list(JSON0),
    maplist(is_digit, Number),
    Number \= [],
    !,
    number_codes(Index, Number),
    nth0(Index, JSON0, JSON).

:- begin_tests(json_pointer).

example_json(JSON) :- atom_json_term(`{
  "wiki": {
    "links": [
      "https://rosettacode.org/wiki/Rosetta_Code",
      "https://discord.com/channels/1011262808001880065"
    ]
  },
  "": "Rosetta",
  " ": "Code",
  "g/h": "chrestomathy",
  "i~j": "site",
  "abc": ["is", "a"],
  "def": { "": "programming" }
}`, JSON, []).

test(entire_document) :-
    example_json(JSON0),
    json_pointer(``, JSON0, JSON),
    assertion(JSON0 == JSON).

test(valid_pointers, [forall(member(Pointer => Expected, [
    `/`              => 'Rosetta',
    `/ `            => 'Code',
    `/abc`          => [is, a],
    `/def/`         => programming,
    `/g~1h`         => chrestomathy,
    `/i~0j`         => site,
    `/wiki/links/0`  => 'https://rosettacode.org/wiki/Rosetta_Code',
    `/wiki/links/1`  => 'https://discord.com/channels/1011262808001880065'
]))]) :-
    example_json(JSON),
    json_pointer(Pointer, JSON, Actual),
    assertion(Actual == Expected).

test(invalid_pointers, [fail, forall(member(Pointer, [
    `/wiki/links/2`, `/wiki/name`, `/no/such/thing`, `bad/pointer`
]))]) :-
    example_json(JSON),
    json_pointer(Pointer, JSON, _).

:- end_tests(json_pointer).
