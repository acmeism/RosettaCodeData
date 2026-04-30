require "http/client"
require "uri"
require "json"

# rosettacode api url #
URL = "https://rosettacode.org/w/api.php"

# categories under these categories are programming languages #
LANG_CATS = ["Programming Languages"]
            .map {|name| "Category:" + name }

# pages in these categories are tasks #
TASKS_CATS = ["Programming Tasks", "Draft Programming Tasks"]
             .map {|name| "Category:" + name }

def get_list (list, prefix, params)
  q = { "action" => "query", "format" => "json", "list" => list,
        prefix + "limit" => "500" }
      .merge(params)
  uri = URI.parse URL
  result = [] of JSON::Any
  loop do
    uri.query = URI::Params.encode q
    response = HTTP::Client.get uri
    json = JSON.parse(response.body)
    result.concat json["query"][list].as_a
    cont = json["continue"]? && json["continue"][prefix + "continue"].to_s
    break unless cont
    q[prefix + "continue"] = cont
  end
  result
end

def get_cat_members (cats, page_type)
  cats.flat_map {|cat|
    get_list("categorymembers", "cm",
             {"cmtitle" => cat, "cmprop" => "ids|title", "cmtype" => page_type})
  }.map {|jo| { jo["pageid"].to_s.to_i, jo["title"].to_s } }
end

module Enumerable(T)
  def rank_by (&)
    result = [] of {Int32, T}
    if present?
      rank = 1
      previous = yield first
      result << {rank, first}
      skip(1).each_with_index do |item, idx|
        key = yield item
        rank = idx+2  unless previous == key
        result << {rank, item}
        previous = key
      end
    end
    result
  end
end

# command line options
load = save = ""
verbose = false
need_help = false
report = "pop"
language = ""

while ARGV.present?
  case opt = ARGV.shift
  when "-l" then load = ARGV.shift
  when "-s" then save = ARGV.shift
  when "-r" then report = ARGV.shift
  when "-v" then verbose = true
  when "-h" then need_help = true
  else
    if report == "ut" && language == ""
      language = opt
    else
      STDERR.puts "Invalid option #{opt}. Use -h for a list of options."
      exit
    end
  end
end
if load != "" && save != ""
  STDERR.puts "Only one of -s or -l is allowed."
  exit
end
unless report.in? ["pop", "ex", "ut"]
  STDERR.puts "Invalid report: #{report}"
  exit
end
if need_help
  STDERR.puts <<-EOH
Usage: #{PROGRAM_NAME} [options]
   -h        show this help
   -v        verbose
   -s FILE   save downloaded data in FILE
   -l FILE   don't download anything, use data in FILE
   -r REPORT report to output:
             pop:     Rank languages by popularity (default)
             ex:      Count examples
             ut LANG: Find unimplemented tasks in LANG
EOH
  exit
end

macro log (s)
  if verbose
    STDERR.print "\r\e[K" + {{s}}
    STDERR.flush
  end
end

if load == ""
  log "Fetching programming languages..."
  all_langs = get_cat_members(LANG_CATS, "subcat")
  log "Fetched #{all_langs.size} programming languages.\n"

  log "Fetching programming tasks..."
  all_tasks = get_cat_members(TASKS_CATS, "page").to_h
  log "Fetched #{all_tasks.size} programming tasks.\n"

  fetch_for = "all languages"
  # when reporting unimplemented tasks, if we're not saving, don't fetch all languages' tasks
  if save == "" && language != ""
    all_langs.reject! {|_, lang| lang.lchop("Category:").upcase != language.upcase }
    fetch_for = language
  end

  i = 0
  tasks_by_lang = all_langs.map {|pageid, cat|
    cat_name = cat.lchop("Category:")
    log "[#{i += 1}/#{all_langs.size}] Fetching tasks for #{cat_name}..."

    lang_tasks = get_cat_members([cat], "page").select {|task_id, _| all_tasks[task_id]? }
                 .map {|_, name| name }

    { cat_name, lang_tasks }
  }
  tasks_by_lang << { "", all_tasks.values }
  log "Fetched tasks for #{fetch_for}.\n"

  if save != ""
    File.open(save, "w") do |f|
      tasks_by_lang.to_json(f)
      log "Data saved to #{save}.\n"
    end
  end
else
  log "Loading data from #{load}..."
  tasks_by_lang = File.open(load) do |f|
    Array({String, Array(String)}).from_json(f)
  end
  log "Loaded #{tasks_by_lang.size} entries from #{load}.\n"
end

if report == "pop"
  tasks_by_lang.reject {|lang, tasks| lang == "" || tasks.size == 0 }
    .sort_by {|lang, tasks| {-tasks.size, lang} }
    .rank_by {|lang, tasks| tasks.size }
    .each do |rank, (lang, tasks)|
    printf("%3d.  %4d  %s\n", rank, tasks.size, lang)
  end
elsif report == "ex"
  tally = Hash(String, Int32).new(0)
  tasks_by_lang.each do |lang, tasks|
    tasks.each do |task|
      tally[task] += 1
    end
  end
  tally.delete ""
  tally.to_a.sort_by {|task, n| {-n, task} }
    .rank_by {|task, n| n }
    .each do |rank, (task, n)|
    printf("%4d.  %3d  %s\n", rank, n, task)
  end
elsif report == "ut"
  ulang = language.upcase
  langtasks = tasks_by_lang.find { |(lang, _)| lang.upcase == ulang }
  if langtasks
    all_tasks = tasks_by_lang.find! { |(lang, _)| lang == "" }.last.to_set
    _, tasks = langtasks
    (all_tasks - tasks).to_a.sort!.each do |task|
      puts task
    end
  else
    STDERR.puts "Language #{language} not found."
    exit 1
  end
end
