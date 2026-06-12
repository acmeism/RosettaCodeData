# Returns all maximal Cliques as sorted List of Lists.
sub BronKerbosch ( @undirected_edges ) {

    #| Adjacency list of the whole Graph, as immutable hash (Map) of immutable Sets.
    my Map $G = @undirected_edges
                .map({ |( .[0,1], .[1,0] ) })
                .classify( {.[0]}, :as{.[1]} )
                .duckmap( *.Set )
                .Map;

    #| Number of neighbors in G
    my Map $degree = $G.map({ .key => .value.elems }).Map;

    return gather BK();

    sub BK (
        Set     :$R         = Set.new,              #= Current clique
        SetHash :$P is copy = SetHash.new($G.keys), #= Potential candidates to expand the clique
        SetHash :$X is copy = SetHash.new,          #= Vertices already processed
    ) {
        if !$P and !$X {
            take $R.keys.sort.cache if $R.elems > 2;
            return;
        }

        my $Pivot = ($P ∪ $X).max({ $degree{$_} }).key;

        my @Candidates = ( $P (-) $G{$Pivot} ).keys;

        for $G{@Candidates}:kv -> $v, $Neighbors_of_v {

            &?ROUTINE.(     # Recursive call with updated sets
                R => ($R ∪ $v),
                P => ($P ∩ $Neighbors_of_v),
                X => ($X ∩ $Neighbors_of_v),
            );

            # Move vertex v from P to X
            $P{$v} = False;
            $X{$v} = True;
        }
    }
}

say .join(",") for sort BronKerbosch <a-b a-c b-c d-e d-f e-f>».split("-");
