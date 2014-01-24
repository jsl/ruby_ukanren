# microKanren in Ruby

A port of microKanren, a minimalistic logic programming language, to Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_ukanren'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_ukanren

## Usage

```ruby
require 'ukanren'
include Ukanren::Language

call_fresh(-> (q) { eq(q, 5) }).call(empty_env)

# The result is a set of nested lambda cons cells equivalent to ((([0] . 5 )) . 1)).
```

See the language_spec for more examples.
## Credits

The code in this gem is closely based on the following sources:

* The [microKanren paper](http://webyrd.net/scheme-2013/papers/HemannMuKanren2013.pdf)
  by Jason Hemann and Daniel P. Friedman. I read this paper a couple of times, and
  will probably have to read it a few more before I have a better understanding
  about what this code is doing and how to write more effective logic programs.
* This code is also in parts copied from
  [Scott Vokes' port of microKanren to Lua](https://github.com/silentbicycle/lua-ukanren).
  It was great to have the Lua code as a second example of the implementation in
  the paper, and it made my job especially easy since Lua is so similar to Ruby.
* Finally, I used the [microKanren examples in Scheme](https://github.com/jasonhemann/microKanren)
  to see if this port worked as expected.

## Contributing

1. Fork it ( http://github.com/jsl/ruby_ukanren/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
