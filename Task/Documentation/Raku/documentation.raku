#= it's yellow
sub marine { ... }
say &marine.WHY; # "it's yellow"

#= a shaggy little thing
class Sheep {
    #= not too scary
    method roar { 'roar!' }
}
say Sheep.WHY; # "a shaggy little thing"
say Sheep.^find_method('roar').WHY; # "not too scary"
