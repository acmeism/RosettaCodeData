class DecisionTable
  def initialize(conditions, actions)
    @conditions = conditions
    @actions = []
    @rules = []
    actions.each {|action, ruleset| @actions << action; @rules << ruleset}
  end

  def run
    puts "Conditions:"
    index = ask_conditions
    puts "Actions:"
    results = @rules.each_with_index.inject([]) do |sum, (ruleset, idx)|
      sum << @actions[idx] if ruleset[index] == 1
      sum
    end
    results << "PC LOAD LETTER" if results.empty?
    results.each {|res| puts "  #{res}"}
    puts ""
  end

  private
  def ask_conditions
    answers = @conditions.inject("") {|sum, c| sum + get_response(c)}
    answers.to_i(2)
  end

  def get_response(prompt)
    loop do
      print "  #{prompt}? "
      case STDIN.gets.strip.downcase
      when /^y/ then return "0"
      when /^n/ then return "1"
      end
    end
  end
end

dt = DecisionTable.new(
      [
        "Printer does not print",              #  Y Y Y Y N N N N
        "A red light is flashing",             #  Y Y N N Y Y N N
        "Printer is unrecognised",             #  Y N Y N Y N Y N
      ],
      [
        ["Check the power cable",                [0,0,1,0,0,0,0,0]],
        ["Check the printer-computer cable",     [1,0,1,0,0,0,0,0]],
        ["Ensure printer software is installed", [1,0,1,0,1,0,1,0]],
        ["Check/replace ink",                    [1,1,0,0,1,1,0,0]],
        ["Check for paper jam",                  [0,1,0,1,0,0,0,0]],
      ]
     )
loop {dt.run}
