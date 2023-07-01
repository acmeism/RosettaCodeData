mp =: +/ . * "2 1

T =: 3 3 3$  1 _2 2 2 _1 2 2 _2 3   1 2 2 2 1 2 2 2 3   _1 2 2 _2 1 2 _2 2 3

branch =: dyad define  NB. Go down one branch of the tree, usage: <perimeter> branch <triple>
    (x >: +/"1 next) # next =. T (/:~ @ mp) y
)

pythag =: monad define  NB. pythagorean triples with max perimeter
    t1 =. 0 3$ 0
    if. y >: 12 do.
        t0 =. 1 3$ 3 4 5
        while. #t0 > 0 do.
            t =. {. t0
            t1 =. t1, t
            t0 =. (}. t0), y branch t
        end.
    end.
    /:~ t1
)

count =: monad define "0  NB. count triples with max perimeter
    y, (#t), +/ <. y % +/"1 t =. pythag y
)

(9!:11) 7  NB. change output precision

echo 'Counts of primitive and total number of Pythagorean triples with perimeter ≤ 10^n.'
echo count 10 ^ >: i.6
exit ''
