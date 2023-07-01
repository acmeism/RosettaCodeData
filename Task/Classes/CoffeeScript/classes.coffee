# Create a basic class
class Rectangle
  # Constructor that accepts one argument
  constructor: (@width) ->

  # An instance variable
  length: 10

  # A method
  area: () ->
    @width * @length

# Instantiate the class using the new operator
rect = new Rectangle 2
