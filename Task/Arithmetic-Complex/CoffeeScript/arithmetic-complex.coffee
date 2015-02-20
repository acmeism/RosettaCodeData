# create an immutable Complex type
class Complex
  constructor: (@r=0, @i=0) ->
    @magnitude = @r*@r + @i*@i

  plus: (c2) ->
    new Complex(
      @r + c2.r,
      @i + c2.i
    )

  times: (c2) ->
    new Complex(
      @r*c2.r - @i*c2.i,
      @r*c2.i + @i*c2.r
    )

  negation: ->
    new Complex(
      -1 * @r,
      -1 * @i
    )

  inverse: ->
    throw Error "no inverse" if @magnitude is 0
    new Complex(
      @r / @magnitude,
      -1 * @i / @magnitude
    )

  toString: ->
    return "#{@r}" if @i == 0
    return "#{@i}i" if @r == 0
    if @i > 0
      "#{@r} + #{@i}i"
    else
      "#{@r} - #{-1 * @i}i"

# test
do ->
  a = new Complex(5, 3)
  b = new Complex(4, -3)

  sum = a.plus b
  console.log "(#{a}) + (#{b}) = #{sum}"

  product = a.times b
  console.log "(#{a}) * (#{b}) = #{product}"

  negation = b.negation()
  console.log "-1 * (#{b}) = #{negation}"

  diff = a.plus negation
  console.log "(#{a}) - (#{b}) = #{diff}"

  inverse = b.inverse()
  console.log "1 / (#{b}) = #{inverse}"

  quotient = product.times inverse
  console.log "(#{product}) / (#{b}) = #{quotient}"
