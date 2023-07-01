# Sample classes for reflection
class Super
  CLASSNAME = 'super'

  def initialize(name)
    @name = name
    def self.superOwn
      'super owned'
    end
  end

  def to_s
    "Super(#{@name})"
  end

  def doSup
    'did super stuff'
  end

  def self.superClassStuff
    'did super class stuff'
  end

  protected
  def protSup
    "Super's protected"
  end

  private
  def privSup
    "Super's private"
  end
end

module Other
  def otherStuff
    'did other stuff'
  end
end

class Sub < Super
  CLASSNAME = 'sub'
  attr_reader :dynamic

  include Other

  def initialize(name, *args)
    super(name)
    @rest = args;
    @dynamic = {}
    def self.subOwn
      'sub owned'
    end
  end

  def methods(regular=true)
    super + @dynamic.keys
  end

  def method_missing(name, *args, &block)
    return super unless @dynamic.member?(name)
    method = @dynamic[name]
    if method.arity > 0
      if method.parameters[0][1] == :self
        args.unshift(self)
      end
      if method.lambda?
        # procs (hence methods) set missing arguments to `nil`, lambdas don't, so extend args explicitly
        args += args + [nil] * [method.arity - args.length, 0].max
        # procs (hence methods) discard extra arguments, lambdas don't, so discard arguments explicitly (unless lambda is variadic)
        if method.parameters[-1][0] != :rest
          args = args[0,method.arity]
        end
      end
      method.call(*args)
    else
      method.call
    end
  end

  def public_methods(all=true)
    super + @dynamic.keys
  end

  def respond_to?(symbol, include_all=false)
    @dynamic.member?(symbol) || super
  end

  def to_s
    "Sub(#{@name})"
  end

  def doSub
    'did sub stuff'
  end

  def self.subClassStuff
    'did sub class stuff'
  end

  protected
  def protSub
    "Sub's protected"
  end

  private
  def privSub
    "Sub's private"
  end
end

sup = Super.new('sup')
sub = Sub.new('sub', 0, 'I', 'two')
sub.dynamic[:incr] = proc {|i| i+1}

p sub.public_methods(false)
#=> [:superOwn, :subOwn, :respond_to?, :method_missing, :to_s, :methods, :public_methods, :dynamic, :doSub, :incr]

p sub.methods - Object.methods
#=> [:superOwn, :subOwn, :method_missing, :dynamic, :doSub, :protSub, :otherStuff, :doSup, :protSup, :incr]

p sub.public_methods - Object.public_methods
#=> [:superOwn, :subOwn, :method_missing, :dynamic, :doSub, :otherStuff, :doSup, :incr]

p sub.methods - sup.methods
#=> [:subOwn, :method_missing, :dynamic, :doSub, :protSub, :otherStuff, :incr]

# singleton/eigenclass methods
p sub.methods(false)
#=> [:superOwn, :subOwn, :incr]
p sub.singleton_methods
#=> [:superOwn, :subOwn]
