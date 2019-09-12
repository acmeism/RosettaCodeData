# Julia 1.0
using Combinatorics
function make(str, test )
  filter(test, collect( permutations(split(str))) )
end

men = make("danish english german norwegian swedish",
           x -> "norwegian" == x[1])

drinks = make("beer coffee milk tea water", x -> "milk" == x[3])

#Julia 1.0 compatible
colors = make("blue green red white yellow",
              x -> 1 == findfirst(c -> c == "white", x) - findfirst(c -> c == "green",x))

pets = make("birds cats dog horse zebra")

smokes = make("blend blue-master dunhill pall-mall prince")

function eq(x, xs, y, ys)
  findfirst(xs, x) == findfirst(ys, y)
end

function adj(x, xs, y, ys)
  1 == abs(findfirst(xs, x) - findfirst(ys, y))
end

function print_houses(n, pet, nationality, colors, drink, smokes)
  println("$n, $pet,    $nationality       $colors       $drink    $smokes")
end

for m = men, c = colors
  if eq("red",c, "english",m) && adj("norwegian",m, "blue",c)
    for d = drinks
      if eq("danish",m, "tea",d) && eq("coffee",d,"green",c)
        for s = smokes
          if eq("yellow",c,"dunhill",s) &&
             eq("blue-master",s,"beer",d) &&
             eq("german",m,"prince",s)
            for p = pets
              if eq("birds",p,"pall-mall",s) &&
                 eq("swedish",m,"dog",p) &&
                 adj("blend",s,"cats",p) &&
                 adj("horse",p,"dunhill",s)
                println("Zebra is owned by ", m[findfirst(c -> c == "zebra", p)])
                println("Houses:")
                for house_num in 1:5
                  print_houses(house_num,p[house_num],m[house_num],c[house_num],d[house_num],s[house_num])
                end
              end
            end
          end
        end
      end
    end
  end
end
