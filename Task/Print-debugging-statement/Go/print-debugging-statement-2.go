(for s (-> (symbols)
           (filter about)
           (remove ["print" "mock" "unmocked" "unmock" "do" "reset"]))
  (mock s (fn (let result ((unmocked ...) (unmocked s) args))
              (print "(" s " " ((unmocked join) " " args) ") => " result)
              result)))

(function inside-2d? X Y areaX areaY areaW areaH
  (and (<= areaX X (+ areaX areaW))
       (<= areaY Y (+ areaY areaH))))

(inside-2d? 50 50 0 0 100 100)
