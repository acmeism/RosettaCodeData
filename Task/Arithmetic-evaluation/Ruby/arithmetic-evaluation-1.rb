$op_priority = {"+" => 0, "-" => 0, "*" => 1, "/" => 1}

class TreeNode
  OP_FUNCTION = {
    "+" => lambda {|x, y| x + y},
    "-" => lambda {|x, y| x - y},
    "*" => lambda {|x, y| x * y},
    "/" => lambda {|x, y| x / y}}
  attr_accessor :info, :left, :right

  def initialize(info)
    @info = info
  end

  def leaf?
    @left.nil? and @right.nil?
  end

  def to_s(order)
    if leaf?
      @info
    else
      left_s, right_s = @left.to_s(order), @right.to_s(order)

      strs = case order
             when :prefix  then [@info, left_s, right_s]
             when :infix   then [left_s, @info, right_s]
             when :postfix then [left_s, right_s, @info]
             else               []
             end

      "(" + strs.join(" ") + ")"
    end
  end

  def eval
    if !leaf? and operator?(@info)
      OP_FUNCTION[@info].call(@left.eval, @right.eval)
    else
      @info.to_f
    end
  end
end

def tokenize(exp)
  exp
    .gsub('(', ' ( ')
    .gsub(')', ' ) ')
    .gsub('+', ' + ')
    .gsub('-', ' - ')
    .gsub('*', ' * ')
    .gsub('/', ' / ')
    .split(' ')
end

def operator?(token)
  $op_priority.has_key?(token)
end

def pop_connect_push(op_stack, node_stack)
  temp = op_stack.pop
  temp.right = node_stack.pop
  temp.left = node_stack.pop
  node_stack.push(temp)
end

def infix_exp_to_tree(exp)
  tokens = tokenize(exp)
  op_stack, node_stack = [], []

  tokens.each do |token|
    if operator?(token)
      # clear stack of higher priority operators
      until (op_stack.empty? or
             op_stack.last.info == "(" or
             $op_priority[op_stack.last.info] < $op_priority[token])
        pop_connect_push(op_stack, node_stack)
      end

      op_stack.push(TreeNode.new(token))
    elsif token == "("
      op_stack.push(TreeNode.new(token))
    elsif token == ")"
      while op_stack.last.info != "("
        pop_connect_push(op_stack, node_stack)
      end

      # throw away the '('
      op_stack.pop
    else
      node_stack.push(TreeNode.new(token))
    end
  end

  until op_stack.empty?
    pop_connect_push(op_stack, node_stack)
  end

  node_stack.last
end
