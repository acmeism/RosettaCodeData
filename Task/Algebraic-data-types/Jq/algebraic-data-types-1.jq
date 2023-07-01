# bindings($x) attempts to match . and $x structurally on the
# assumption that . is free of JSON objects, and that any objects in
# $x will have distinct, singleton keys that are to be interpreted as
# variables.  These variables will match the corresponding entities in
# . if . and $x can be structurally matched.
#
# If . and $x cannot be matched, then null is returned;
# otherwise, if $x contains no objects, {} is returned;
# finally, if . and $x can be structurally matched, a composite object containing the bindings
# will be returned.
# Output: null (failure to match) or a single JSON object giving the bindings if any.
def bindings($x):
   if $x == . then {}  # by assumption, no bindings are necessary
   elif ($x|type) == "object"
   then ($x|keys) as $keys
   | if ($keys|length) == 1 then {($keys[0]): .} else "objects should be singletons"|error end
   elif type != ($x|type) then null
   elif type == "array"
   then if length != ($x|length) then null
        else . as $in
        | reduce range(0;length) as $i ({};
            if . == null then null
            else ($in[$i] | bindings($x[$i]) ) as $m
            | if $m == null then null else . + $m end
            end)
	end
   else null
   end ;
