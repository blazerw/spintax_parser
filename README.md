# spintax_parser

A mixin to parse "spintax", a text format used for automated article generation. Can handle nested spintax, and can count the total number of unique variations.

Based on Ruby version, [GitHub](https://github.com/flintinatux/spintax_parser) (So, is this README. `:^)` )

[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://blazerw.github.io/spintax_parser/)
[![GitHub release](https://img.shields.io/github/release/blazerw/spintax_parser.svg)](https://github.com/blazerw/spintax_parser/releases)

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  spintax_parser:
    github: blazerw/spintax_parser
```
2. Run `shards install`

## Usage

```crystal
require "spintax_parser"

class String
  include SpintaxParser
end
```

Then you can safely call `#unspin` on any string in your application:

```crystal
spintext = "{Hello|Hi} {{world|worlds}|planet}{!|.|?}"
10.times do
  puts spintext.unspin
end
```

Run the code above, and you will end up with several random variations of the same text, such as:

    Hi worlds.
    Hi planet?
    Hello world?
    Hi planet?
    Hi world?
    Hi world!
    Hi world.
    Hello world.
    Hello world!
    Hello worlds.

And don't worry: calling `#unspin` on a string with no spintax will safely return an unaffected copy of the string.

Also, note that the `#unspin` method doesn't really care if the class you mix it into is a descendant of `String` or not, as long as its `#to_s` method returns a string written in spintax.

### Consistent unspinning

Got a special project that requires unspinning the same spintax the same way in certain circumstances? No problem. If you're using a Ruby version >= 1.9.3, you can pass a pre-seeded random number generator to the `#unspin` method just like you would to the `Array#sample` method. Et voila! Consistent unspinning!

```crystal
seed = Random::PCG32.new.new_seed
spintext.unspin Random.new(seed)  # => "Hello world!"
spintext.unspin Random.new(seed)  # => "Hello world!"
```

### Counting total variations

You can also count the total number of unique variations of a spintax string. If you've mixed the `SpintaxParser` into your `String` class like above, just call the `#count_spintax_variations` method on any string as shown below:

```crystal
spintext = "{Hello|Hi} {{world|worlds}|planet}{!|.|?}"
spintext.count_spintax_variations  # => 18
```

NOTE: The following currently fails:

```crystal
expect("{one|two|}".count_spintax_variations).to eq 3
```

## Development

Follow Crystal's guidelines: https://crystal-lang.org/reference/guides/writing_shards.html and realize that [Spec2](https://github.com/waterlink/spec2.cr) is used for testing, specifically this [fork](https://github.com/ThunderKey/spec2.cr)

## Contributing

1. Fork it (<https://github.com/blazerw/spintax_parser/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Randy Wilson](https://github.com/blazerw) - creator and maintainer
