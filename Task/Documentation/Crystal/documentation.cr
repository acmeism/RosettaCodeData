# Any block of comments *directly* before (no blank lines) a module, class, or method is used as a doc comment
# This one is for a module
module Documentation

  # This comment documents a class, *and* it uses markdown
  class Foo

    # This comment doesn't do anything, because it isn't directly above a module, class, or method

    # Finally, this comment documents a method
    def initialize
    end
  end
end
