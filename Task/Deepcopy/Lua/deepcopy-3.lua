function deepcopy(o, mode)

  if type(o) ~= 'table' then
    return o
  end

  mode = mode and mode:lower() or 'v'
  local deep_keys   = mode:find('k')
  local deep_values = mode:find('v')

  local tables = {[o] = {}} -- list of known tables (to handle circular tables)
  local stack = {o}         -- first table which will be popped from stack is the root table
                            --   and the key must be `nil` because we are at the beginning
                            --   of the root table. since it's `nil`, we don't need to put it
                            --   on the stack - `table.remove()` will by default return `nil`
                            --   when called on an empty table.

  while #stack ~= 0 do
    local t, new_t, k, v = table.remove(stack)  -- assigns only to `t`,
                                                --   other variables are set to `nil`
    if t ~= 0 then
      k = table.remove(stack) -- restore the context

    else  -- we finished copying the key, now copy the value
      t = stack[#stack]    -- get the parent table to retrieve the value from
      k = stack[#stack-1]  -- get saved key
      t = t[k]  -- retrieve the value from the parent table and set it as the current table
      k = nil   -- reset key (start traversing the value table from the beginning)
    end
    new_t = tables[t] -- get the new table from the list of known tables

    if k ~= nil then  -- this is always true except for
                      --  1. when we just popped the root table `o`
                      --  2. when we just finished copying the key table
                      --     and now we have to copy the value table
      local v = t[k]  -- get the original value
                      -- if we want to deep-copy keys, then get its copy from the list
                      --   of known tables. if it's not there, then it isn't a table,
                      --   so keep its original value. same goes for the value.
      if deep_keys   then k = tables[k] or k end
      if deep_values then v = tables[v] or v end
      new_t[k] = v    -- put value into the new table
    end

    k,v = next(t,k) -- in case we have just started traversing the root table `o`, this retrieves
                    --   the first key and value, as well as in case we have just finished copying
                    --   the key table and are now copying the value table. otherwise, it continues
                    --   where we left off when we descended into subtable.

    while k ~= nil do
      -- we need to deep-copy the key/value only if
      --  1. we want to do it (eg. `mode` specifies to deep-copy keys/values), AND
      --  2. it is a table, AND
      --  3. we haven't copied it already (and are not copying it right now)
      local copy_key   = deep_keys   and type(k) == 'table' and not tables[k]
      local copy_value = deep_values and type(v) == 'table' and not tables[v]

      if not copy_key and not copy_value then -- boring stuff
        -- if either `deep_keys` is `nil` (we don't want to deep-copy keys)
        --   or `tables[k]` is `nil` (the key is not a table), then keep the key's original value,
        --   otherwise use the value saved in `tables`. same goes for the value.
        local new_k = deep_keys   and tables[k] or k
        local new_v = deep_values and tables[v] or v
        new_t[new_k] = new_v  -- put the value into the new table

      else -- copy_key or copy_value
        stack[#stack+1] = k -- save current context
        stack[#stack+1] = t

        if copy_key then
          t = k   -- descend into the key table
          if copy_value then
            stack[#stack+1] = 0 -- remember we have to copy the value table as well
            tables[v] = {}      -- create new table for the value beforehand
          end
        else -- copy only the value
          t = v  -- descent into the value table
        end

        new_t = {}        -- create new table
        tables[t] = new_t -- add it to the list of known tables
        k = nil           -- reset the key
      end

      k,v = next(t,k) -- get next key/value (or first, in case we just descended into a subtable)
    end
  end

  return tables[o]  -- return the copy corresponding to the root table `o`
end
