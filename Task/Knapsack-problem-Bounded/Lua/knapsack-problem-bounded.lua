#!/usr/bin/env  lua

--- knapsack packing for max value under wieght limit

 -- A: use value/weight score as pre-sort
 -- B: initial run with no items excluded
 -- C: try combos excluding each item for best value


--- table of tables
-- {name                  weight  value quantity   wt/val }
items =  {
   {"map",                 9,  150,  1},
   {"compass",		      13,   35,	 1},
   {"water",		     153,  200,  2},
   {"sandwich",		      50,   60,	 2},
   {"glucose",		      15,   60,	 2},
   {"tin",		          68,   45,	 3},
   {"banana",		      27,   60,	 3},
   {"apple",		      39,   40,	 3},
   {"cheese",		      23,   30,	 1},
   {"beer",		          52,   10,	 3},
   {"suntan cream",	      11,   70,	 1},
   {"camera",		      32,   30,	 1},
   {"t-shirt",		      24,   15,	 2},
   {"trousers",		      48,   10,	 2},
   {"umbrella",		      73,   40,	 1},
   {"waterproof trousers",    42,   70,	 1},
   {"waterproof overclothes", 43,   75,	 1},
   {"note-case",	      22,   80,  1},
   {"sunglasses",	       7,   20,  1},
   {"towel",		      18,   12,	 2},
   {"socks",		       4,   50,	 1},
   {"book",		          30,   10,	 2},
}

-- for output
function print_as_sack(its)
   if its == nil then return end

   -- format columns
   -- [20                  |8     |8     |8     ]
   local head_fmt = "%-20s\t%-8s\t%-8s\t%-8s"
   local data_fmt = "%-20s\t%-8d\t%-8d\t%-8d"

   local head_table =
      string.format(head_fmt, "item", "weight", "value", "quantity")

   io.write(head_table, "\n")
   line = string.rep("-" , 64)
   io.write(line, "\n")

   for n=1,#its do
      it = its[n]
      local name,wt,val,q = table.unpack(it)

      local fmt_table =
	 string.format(data_fmt, name, wt, val, q)
      io.write(fmt_table, "\n")
   end
   io.write(line, "\n")
end

-- calc value:weight ratio
function append_wv (its)

   for index, it in pairs(its) do
      local name,wt,val,q = table.unpack(it)
      wv  =  val / wt
      it[#it+1] = wv -- append
   end
end

-- sort by 5th item of each table entry
function sort_by_wv (its)
   -- sorts decreasing
   local wv_sorter = function(a,b) return a[5] > b[5] end
   table.sort(its, wv_sorter)
end

-- pack sorted by v:w ratio
-- all or none per item
function add_up (its, max, excl)

   local sack_items = {}
   local sack = {}
   local this_weight = 0
   local this_value  = 0

   for i = 1,#its do
      it = its[i]

      -- is same table?
      --    lua has no continue keyword
      if it == excl then goto continue end

      -- unpack into vars
      local name,wt,val,q,wv = table.unpack(it)
      local count  = 0
      local w      = 0
      for j = 1, q do
	     local t_wt = wt +this_weight
	     if t_wt < max then
	        this_value  = this_value + val
	        this_weight = t_wt
	        count = count + 1
	     end
      end

      if this_weight >= max then break end

      if count > 0 then
	     _s = {name, count}
	     table.insert (sack, _s)
      end

      ::continue::  --skip item, continue
   end  -- for items

   -- go through chosen sack
   -- make sack of items
      for s = 1,#sack do
	     local s_item  = sack[s]
	     local s_name,s_count = table.unpack(s_item)

   	     for j = 1,#its do	
	        local it = its[j]
	        local iname = it[1]
	        if iname == s_name then
	           it[4] = s_count
	           table.insert(sack_items, it)
	        end -- if
	     end -- for j
     end -- for sack

      -- update best
      if this_value > best_value then
	     best_value = this_value
	     best_weight = this_weight
	     best_sack = sack_items
      end
end  -- function add_up

-- Main execution
if debug.getinfo(1).what == "main" then

   max_weight = 400
   best_weight = 0
   best_value  = 0
   best_sack = {}

   start = os.clock()

   append_wv(items)   -- add weight/value

   sort_by_wv(items)  -- sort by wv

   add_up(items, max_weight, {}) -- first try

   -- with each item excluded
   for i = 1, #items do
      add_up(items, max_weight, items[i])
   end

   stop = os.clock()

   time = stop - start     -- seconds

   usec_time = time * 1e6 --microseconds


   -- output
   print_as_sack(best_sack)
   print ("value:\t", best_value)
   print("weight:\t", best_weight)
   print("time:\t" , usec_time , " usec")

   os.exit(0)
end
-- end
