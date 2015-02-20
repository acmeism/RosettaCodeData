:- use_module([ library(http/json),
                library(func) ]).

test_json('{"widget": { "debug": "on", "window": { "title": "Sample Konfabulator Widget", "name": "main_window", "width": 500, "height": 500 }, "image": { "src": "Images/Sun.png", "name": "sun1", "hOffset": 250, "vOffset": 250, "alignment": "center" }, "text": { "data": "Click Here", "size": 36, "style": "bold", "name": "text1", "hOffset": 250, "vOffset": 100, "alignment": "center", "onMouseUp": "sun1.opacity = (sun1.opacity / 100) * 90;" }}}').

reading_JSON_term :-
    atom_json_dict(test_json(~), Dict, []), %% This accomplishes reading in the JSON data
    writeln( 'JSON as Prolog dict: ~w~n'
           $ Dict),
    writeln( 'Access field "widget.text.data": ~s~n'
           $ Dict.widget.text.data),
    writeln( 'Alter field "widget": ~w~n'
           $ Dict.put(widget, "Altered")).

searalize_a_JSON_term :-
    Dict = _{book:_{title:"To Mock a Mocking Bird",
                    author:_{first_name:"Ramond",
                             last_name:"Smullyan"},
                    publisher:"Alfred A. Knopf",
                    year:1985
                   }},
    json_write(current_output, Dict). %% This accomplishes serializing the JSON object.
