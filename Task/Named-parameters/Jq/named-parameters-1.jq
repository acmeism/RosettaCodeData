def formatName(obj):
  ({ "name": "?"} + obj) as $obj  # the default default value is null
  | ($obj|.name) as $name
  | ($obj|.first) as $first
  | if ($first == null) then $name
    else $name + ", " + $first
    end;
