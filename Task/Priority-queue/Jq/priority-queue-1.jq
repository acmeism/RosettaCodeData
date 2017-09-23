# In the following, pq stands for "priority queue".

# Add an item with the given priority (an integer,
# or a string representing an integer)
# Input: a pq
def pq_add(priority; item):
  (priority|tostring) as $p
  | if .priorities|index($p) then
      if (.[$p] | index(item)) then . else .[$p] += [item] end
    else .[$p] = [item] | .priorities = (.priorities + [$p] | sort)
    end ;

# emit [ item, pq ]
# Input: a pq
def pq_pop:
  .priorities as $keys
  | if ($keys|length) == 0 then [ null, . ]
    else
      if (.[$keys[0]] | length) == 1
      then .priorities =  .priorities[1:]
      else .
      end
      | [ (.[$keys[0]])[0], (.[$keys[0]] = .[$keys[0]][1:]) ]
    end ;

# Emit the item that would be popped, or null if there is none
# Input: a pq
def pq_peep:
  .priorities as $keys
  | if ($keys|length) == 0 then null
    else (.[$keys[0]])[0]
    end ;

# Add a bunch of tasks, presented as an array of arrays
# Input: a pq
def pq_add_tasks(list):
  reduce list[] as $pair (.; . + pq_add( $pair[0]; $pair[1]) ) ;

# Pop all the tasks, producing a stream
# Input: a pq
def pq_pop_tasks:
  pq_pop as $pair
  | if $pair[0] == null then empty
    else $pair[0], ( $pair[1] | pq_pop_tasks )
    end ;

# Input: a bunch of tasks, presented as an array of arrays
def prioritize:
  . as $list | {} | pq_add_tasks($list) | pq_pop_tasks ;
