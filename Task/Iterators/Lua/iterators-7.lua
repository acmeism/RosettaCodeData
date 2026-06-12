> LinkedList = require("linked_list")
> Iters = require("iters")
> days = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
> colors = LinkedList.from_list({"Red","Orange","Yellow","Green","Blue","Purple"})
> Iters.nth(1, ipairs(days))
1 Sunday
> Iters.nth(4, ipairs(days))
4 Wednesday
> Iters.nth(5, ipairs(days))
5 Thursday
> Iters.nth(1, colors:pairs())
LinkedList: 0x60ea721d2600  Red
> Iters.nth(4, colors:pairs())
LinkedList: 0x60ea721d0cf0  Green
> Iters.nth(5, colors:pairs())
LinkedList: 0x60ea721ce280  Blue
> Iters.nth_last(1, ipairs(days))
7 Saturday
> Iters.nth_last(4, ipairs(days))
4 Wednesday
> Iters.nth_last(5, ipairs(days))
3 Tuesday
> Iters.nth_last(1, colors:pairs())
LinkedList: 0x60ea721cccf0  Purple
> Iters.nth_last(4, colors:pairs())
LinkedList: 0x60ea721d0d70  Yellow
> Iters.nth_last(5, colors:pairs())
LinkedList: 0x60ea721d0df0  Orange
