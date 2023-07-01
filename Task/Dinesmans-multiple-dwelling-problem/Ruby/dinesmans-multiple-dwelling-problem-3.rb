names = %i( Baker Cooper Fletcher Miller Smith )

predicates = [->(c){ :Baker != c.last },
              ->(c){ :Cooper != c.first },
              ->(c){ :Fletcher != c.first && :Fletcher != c.last },
              ->(c){ c.index(:Miller) > c.index(:Cooper) },
              ->(c){ (c.index(:Smith) - c.index(:Fletcher)).abs != 1 },
              ->(c){ (c.index(:Cooper) - c.index(:Fletcher)).abs != 1 }]

puts names.permutation.detect{|candidate| predicates.all?{|predicate| predicate.call(candidate)}}
