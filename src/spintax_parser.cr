require "./spintax_parser/version"
require "naive_mather"

# A mixin to parse "spintax", a text format used for
# automated article generation. Can handle nested
# spintax, and can count the total number of unique
# variations.
#
# ```
# class String
#   include SpintaxParser
# end
# ```
module SpintaxParser
  SPINTAX_PATTERN = /\{([^{}]*)\}/

  # Returns the unspun version of some spintext.
  #
  # ```
  # "{Fred|George} is {blue|red}.".unspin
  #  > "Fred is red."
  # ```
  def unspin(random = Random::DEFAULT)
    spun = dup.to_s
    while spun =~ SPINTAX_PATTERN
      spun = parse_the_spintax_in(spun, random)
    end
    spun
  end

  # Returns count of variations for spintax.
  #
  # ```
  # "{Fred|George} is {blue|red}.".count_spintax_variations
  #  > 4
  # ```
  def count_spintax_variations
    spun = dup.to_s
    while spun =~ /([\{\|])([\|\}])/
      spun = spun.gsub /([\{\|])([\|\}])/, "\11\2"
    end
    spun = spun.gsub /[^{|}]+/, "1"
    spun = spun.gsub /\{/, "("
    spun = spun.gsub /\|/, "+"
    spun = spun.gsub /\}/, ")"
    spun = spun.gsub /\)\(/, ")*("
    spun = spun.gsub /\)1/, ")*1"
    spun = spun.gsub /1\(/, "1*("
    begin
      calc(spun)
    rescue ex # SyntaxError
      nil
    end
  end

  private def calc(string)
    NaiveMather.calculate(string)
  end

  private def parse_the_spintax_in(spun, random = Random::DEFAULT)
    spun.gsub(SPINTAX_PATTERN) { $1.split("|").sample(1, random).first }
  end
end
