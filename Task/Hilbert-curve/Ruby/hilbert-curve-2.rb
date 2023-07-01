# common library class for lsystems in JRubyArt
class Grammar
  attr_reader :axiom, :rules
  def initialize(axiom, rules)
    @axiom = axiom
    @rules = rules
  end

  def apply_rules(prod)
    prod.gsub(/./) { |token| rules.fetch(token, token) }
  end

  def generate(gen)
    return axiom if gen.zero?

    prod = axiom
    gen.times do
      prod = apply_rules(prod)
    end
    prod
  end
end
