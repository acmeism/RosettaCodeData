module BananaBox = MakeFoodBox (Banana)
module FloatBox = MakeFoodBox (EatFloat)

let my_box = BananaBox.make_box_from_list [Foo]
let your_box = FloatBox.make_box_from_list [2.3; 4.5]
