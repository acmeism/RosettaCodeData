local requests = require('requests')
local lang = arg[1]

local function merge_tables(existing, from_req)
  local result = existing

  for _, v in ipairs(from_req) do
      result[v.title] = true
  end

  return result
end

local function get_task_list(category)
  local url = 'http://www.rosettacode.org/mw/api.php'
  local query = {
    action = 'query',
    list = 'categorymembers',
    cmtitle = string.format('Category:%s', category),
    cmlimit = 500,
    cmtype = 'page',
    format = 'json'
  }
  local categories = {}

  while true do
    local resp = assert(requests.get({ url, params = query }).json())

    categories = merge_tables(categories, resp.query.categorymembers)

    if resp.continue then
      query.cmcontinue = resp.continue.cmcontinue
    else
      break
    end
  end

  return categories
end

local function get_open_tasks(lang)
  if not lang then error('Language missing!') end
  local all_tasks = get_task_list('Programming_Tasks')
  local lang_tasks = get_task_list(lang)
  local task_list = {}

  for t, _ in pairs(all_tasks) do
    if not lang_tasks[t] then
      table.insert(task_list, t)
    end
  end

  table.sort(task_list)
  return task_list
end

local open_tasks = get_open_tasks(lang)

io.write(string.format('%s has %d unimplemented programming tasks: \n', lang, #open_tasks))
for _, t in ipairs(open_tasks) do
  io.write(string.format('  %s\n', t))
end
