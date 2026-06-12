# A FencedHash acts like a Hash, but with a fence around its keys.
# One may change its values, but not its keys.  Any attempt to insert
# a new key raises KeyError.  One may delete a key, but this only
# restores its original value.
#
# FencedHash reimplements these Hash methods: #[] #[]= #clear #delete
# #delete_if #default #default= #each_key #each_pair #each_value
# #fetch #has_key? #keep_if #keys #length #values #values_at
class FencedHash

  # call-seq:
  #   FencedHash.new(hash, obj=nil)  -> fh
  #
  # Creates a FencedHash that takes its keys and original values from
  # a source _hash_.  The source _hash_ can be any object that
  # responds to each_pair.  Sets the default value for missing keys to
  # _obj_, so FencedHash#[] returns _obj_ when a key is not in fence.
  def initialize(hash, obj=nil)
    @default = obj
    @hash = {}
    hash.each_pair do |key, value|
      # @hash[key][0] = current value
      # @hash[key][1] = original value
      @hash[key] = [value, value]
    end
  end

  def initialize_clone(orig)
    # Object#clone calls here in Ruby 2.0.  If _orig_ was frozen, then
    # each array of _values_ is frozen, so make frozen clones.
    super
    copy = {}
    @hash.each_pair {|key, values| copy[key] = values.clone }
    @hash = copy
  end

  def initialize_dup(orig)
    # Object#dup calls here in Ruby 2.0.  If _orig_ was frozen, then
    # make duplicates that are not frozen.
    super
    copy = {}
    @hash.each_pair {|key, values| copy[key] = values.dup }
    @hash = copy
  end

  # Retrieves current value for _key_, like Hash#[].  If _key_ is not
  # in fence, returns default object.
  def [](key)
    values = @hash[key]
    if values
      values[0]
    else
      @default
    end
  end

  # call-seq:
  #   fh[key] = value       -> value
  #   fh.store(key, value)  -> value
  #
  # Sets _value_ for a _key_.  Returns _value.  If _key_ is not in
  # fence, raises KeyError.
  def []=(key, value)
    values = @hash[key]
    if values
      values[0] = value
    else
      raise KeyError, "fence prevents adding new key: #{key.inspect}"
    end
  end
  alias store []=

  # Resets all keys to their original values.  Returns self.
  def clear
    @hash.each_value {|values| values[0] = values[1]}
    self
  end

  # Resets _key_ to its original value.  Returns old value before
  # reset.  If _key_ is not in fence, returns +nil+.
  def delete(key)
    values = @hash[key]
    if values
      old = values[0]
      values[0] = values[1]
      old  # return old
    end    # else return nil
  end

  # call-seq:
  #   fh.delete_if {|key, value| block }  -> fh
  #   fh.delete_if                        -> enumerator
  #
  # Yields each _key_ with current _value_ to _block_.  Resets _key_
  # to its original value when block evaluates to true.
  def delete_if
    if block_given?
      @hash.each_pair do |key, values|
        yield(key, values[0]) and values[0] = values[1]
      end
      self
    else
      enum_for(:delete_if) { @hash.size }
    end
  end

  # The default value for keys not in fence.
  attr_accessor :default

  # call-seq:
  #   fh.each_key {|key| block}  -> fh
  #   fh.each_key                -> enumerator
  #
  # Yields each key in fence to the block.
  def each_key(&block)
    if block
      @hash.each_key(&block)
      self
    else
      enum_for(:each_key) { @hash.size }
    end
  end

  # call-seq:
  #   fh.each_pair {|key, value| block}  -> fh
  #   fh.each_pair                       -> enumerator
  #
  # Yields each key-value pair to the block, like Hash#each_pair.
  # This yields each [key, value] as an array of 2 elements.
  def each_pair
    if block_given?
      @hash.each_pair {|key, values| yield [key, values[0]] }
      self
    else
      enum_for(:each_pair) { @hash.size }
    end
  end

  # call-seq
  #   fh.each_value {|value| block} -> fh
  #   fh.each_value                 -> enumerator
  #
  # Yields current value of each key-value pair to the block.
  def each_value
    if block_given?
      @hash.each_value {|values| yield values[0] }
    else
      enum_for(:each_value) { @hash.size }
    end
  end

  # call-seq:
  #   fenhsh.fetch(key [,default])
  #   fenhsh.fetch(key) {|key| block }
  #
  # Fetches value for _key_.  Takes same arguments as Hash#fetch.
  def fetch(*argv)
    argc = argv.length
    unless argc.between?(1, 2)
      raise(ArgumentError,
            "wrong number of arguments (#{argc} for 1..2)")
    end
    if argc == 2 and block_given?
      warn("#{caller[0]}: warning: " +
           "block supersedes default value argument")
    end

    key, default = argv
    values = @hash[key]
    if values
      values[0]
    elsif block_given?
      yield key
    elsif argc == 2
      default
    else
      raise KeyError, "key not found: #{key.inspect}"
    end
  end

  # Freezes this FencedHash.
  def freeze
    @hash.each_value {|values| values.freeze }
    super
  end

  # Returns true if _key_ is in fence.
  def has_key?(key)
    @hash.has_key?(key)
  end
  alias include? has_key?
  alias member? has_key?

  # call-seq:
  #   fh.keep_if {|key, value| block }  -> fh
  #   fh.keep_if                        -> enumerator
  #
  # Yields each _key_ with current _value_ to _block_.  Resets _key_
  # to its original value when block evaluates to false.
  def keep_if
    if block_given?
      @hash.each_pair do |key, values|
        yield(key, values[0]) or values[0] = values[1]
      end
      self
    else
      enum_for(:keep_if) { @hash.size }
    end
  end

  # Returns array of keys in fence.
  def keys
    @hash.keys
  end

  # Returns number of key-value pairs.
  def length
    @hash.length
  end
  alias size length

  # Converts self to a regular Hash.
  def to_h
    result = Hash.new(@default)
    @hash.each_pair {|key, values| result[key] = values[0]}
    result
  end

  # Converts self to a String.
  def to_s
    "#<#{self.class}: #{to_h}>"
  end
  alias inspect to_s

  # Returns array of current values.
  def values
    @hash.each_value.map {|values| values[0]}
  end

  # Returns array of current values for keys, like Hash#values_at.
  def values_at(*keys)
    keys.map {|key| self[key]}
  end
end
