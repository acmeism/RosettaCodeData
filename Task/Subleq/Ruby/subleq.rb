class Computer
  def initialize program
    @memory = program.map &:to_i
    @instruction_pointer = 0
  end

  def step
    return nil if @instruction_pointer < 0

    a, b, c = @memory[@instruction_pointer .. @instruction_pointer + 2]
    @instruction_pointer += 3

    if a == -1
      b = readchar
    elsif b == -1
      writechar @memory[a]
    else
      difference = @memory[b] -= @memory[a]
      @instruction_pointer = c if difference <= 0
    end

    @instruction_pointer
  end

  def run
    current_pointer = @instruction_pointer
    current_pointer = step while current_pointer >= 0
  end

  private

  def readchar
    gets[0].ord
  end

  def writechar code_point
    print code_point.chr
  end
end

subleq = Computer.new ARGV

subleq.run
