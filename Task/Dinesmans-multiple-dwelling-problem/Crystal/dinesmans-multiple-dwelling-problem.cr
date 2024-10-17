module Enumerable(T)
    def index!(element)
        index(element).not_nil!
    end
end

residents = [:Baker, :Cooper, :Fletcher, :Miller, :Smith]

predicates = [
    ->(p : Array(Symbol)){ :Baker != p.last },
    ->(p : Array(Symbol)){ :Cooper != p.first },
    ->(p : Array(Symbol)){ :Fletcher != p.first && :Fletcher != p.last },
    ->(p : Array(Symbol)){ p.index!(:Miller) > p.index!(:Cooper) },
    ->(p : Array(Symbol)){ (p.index!(:Smith) - p.index!(:Fletcher)).abs != 1 },
    ->(p : Array(Symbol)){ (p.index!(:Cooper) - p.index!(:Fletcher)).abs != 1}
]

puts residents.permutations.find { |p| predicates.all? &.call p }
