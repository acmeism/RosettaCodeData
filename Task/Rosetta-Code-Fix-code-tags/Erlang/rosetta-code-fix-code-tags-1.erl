#! /usr/bin/env escript
-module( fix_code_tags ).
-mode( compile ).

main( _ ) ->
	File_lines = loop( io:get_line(""), [] ),
	Code_fixed_lines = fix_code_tag( binary:list_to_bin(File_lines) ),
%	true = code:add_pathz( "ebin" ),
%	ok = find_unimplemented_tasks:init(),
%	Dict = dict:from_list( [dict_tuple(X) || X <- rank_languages_by_popularity:rosettacode_languages()],
	Dict = dict:from_list( [dict_tuple(X) || X <- ["foo", "bar", "baz"]] ),
	{_Dict, All_fixed_lines} = lists:foldl( fun fix_language_tag/2, {Dict, Code_fixed_lines}, dict:fetch_keys(Dict) ),
	io:fwrite( "~s", [binary:bin_to_list(All_fixed_lines)] ).



dict_tuple( Language ) -> {binary:list_to_bin(string:to_lower(Language)), binary:list_to_bin(Language)}.

fix_code_tag( Binary ) ->
	Avoid_wiki = binary:list_to_bin( [<<"<">>, <<"lang ">>] ),
	Code_fixed_lines = binary:replace( Binary, <<"<code ">>, Avoid_wiki, [global] ),
	Avoid_wiki_again = binary:list_to_bin( [<<"</">>, <<"lang ">>] ),
	binary:replace( Code_fixed_lines, <<"</code>">>, Avoid_wiki_again, [global] ).

fix_language_tag( Language_key, {Dict, Binary} ) ->
	Language = fix_language_tag_rosettacode_language( Language_key, dict:find(Language_key, Dict) ),
	Language_start_old = binary:list_to_bin( [<<"<">>, Language, <<">">>] ),
	Language_start_new = binary:list_to_bin( [<<"<">>, <<"lang ">>, Language, <<">">>] ),
	Fixed_lines = binary:replace( Binary, Language_start_old, Language_start_new, [global] ),
	Language_stop_old = binary:list_to_bin( [<<"</">>, Language, <<">">>] ),
	Language_stop_new = binary:list_to_bin( [<<"</">>, <<"lang>">>] ),
	{Dict, binary:replace( Fixed_lines, Language_stop_old, Language_stop_new, [global] )}.

fix_language_tag_rosettacode_language( _Language_key, {ok, Language} ) -> Language;
fix_language_tag_rosettacode_language( Language_key, error ) -> Language_key.

loop( eof, Acc ) -> lists:reverse( Acc );
loop( Line, Acc ) -> loop( io:get_line(""), [Line | Acc] ).
