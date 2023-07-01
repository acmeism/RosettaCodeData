# Project : Old Russian measure of length

decimals(7)
units = ["tochka", "liniya", "dyuim", "vershok", "piad", "fut",
             "arshin", "sazhen", "versta", "milia",
             "centimeter", "meter", "kilometer"]

convs = [0.0254, 0.254, 2.54, 4.445, 17.78, 30.48,
             71.12, 213.36, 10668, 74676,
             1, 100, 10000]

yn = "y"
unit = 1
p = 1
while yn != "n"
      for i = 1 to 13
          see "" + i + " " + units[i] + nl
      next
      see nl
      see "please choose a unit 1 to 13 : "
      give unit
      see nl
      see "now enter a value in that unit : "
      give value
      see nl
      see "the equivalent in the remaining units is : "
      see nl
      for i = 1 to 13
          if i = unit
             loop
          ok
          see "" + units[i] + " : " + (value * convs[number(unit)] / convs[i]) + nl
      next
      see nl
      while yn = "y" or yn = "n"
              see "do another one y/n : "
              give yn
              yn = lower(yn)
      end
end
