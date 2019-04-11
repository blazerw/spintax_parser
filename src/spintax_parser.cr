require "./spintax_parser/version"
require "ecr/processor"
require "./calculator/parser"

module SpintaxParser
  SPINTAX_PATTERN = /\{([^{}]*)\}/

  def unspin(random = Random::DEFAULT)
    spun = dup.to_s
    while spun =~ SPINTAX_PATTERN
      spun = parse_the_spintax_in(spun, random)
    end
    spun
  end

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
    parser = Parser.new
    parser.parse(string)
  end

  private def parse_the_spintax_in(spun, random = Random::DEFAULT)
    spun.gsub(SPINTAX_PATTERN) { $1.split("|", -1).sample(1, random) }
  end
end
