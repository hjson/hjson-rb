# Hjson, the Human JSON written in Ruby

[![Build Status](https://img.shields.io/travis/hjson/hjson-rb.svg?style=flat-square)](http://travis-ci.org/hjson/hjson-rb)
[![gem](https://img.shields.io/gem/v/hjson.svg?style=flat-square)](https://rubygems.org/gems/hjson)
[![License](https://img.shields.io/github/license/hjson/hjson-rb.svg?style=flat-square)](https://github.com/hjson/hjson-rb/blob/master/LICENSE.txt)

A configuration file format for humans. Relaxed syntax, fewer mistakes, more comments for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hjson'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hjson

## Usage

You can use Hjson as `JSON.parse` of standard library.

Please check it out.

```ruby
require 'hjson'

hjson = <<HJSON
// for your config
// use #, // or /**/ comments,
// omit quotes for keys
key: 1
// omit quotes for strings
string: contains everything until LF
// omit commas at the end of a line
cool: {
  foo: 1
  bar: 2
}
// allow trailing commas
list: [
  1,
  2,
]
// and use multiline strings
realist:
  '''
  My half empty glass,
  I will fill your empty half.
  Now you are half full.
  '''
HJSON

Hjson.parse(hjson)
```

### Comments

Hjson allows you to use comments in your JSON.

```ruby
require 'hjson'

hjson =<<HJSON
{
  # specify rate in requests/second
  "rate": 1000

  // prefer c-style comments?
  /* feeling old fashioned? */
}
HJSON

Hjson.parse(hjson) #=> {"rate"=>1000}
```

### Quotes

You don't need to quote keyname.

```ruby
require 'hjson'

hjson =<<HJSON
{
  key: "value"
}
HJSON

Hjson.parse(hjson) #=> {"key"=>"value"}
```

### Commas

You can forget the comma at the end, Hjson recognizes the end automatically.


```ruby
require 'hjson'

hjson =<<HJSON
{
  one: 1
  two: 2
  three: 4 # oops
}
HJSON

Hjson.parse(hjson) #=> {"one"=>1, "two"=>2, "three"=>4}
```

### Quoteless

Hjson makes quotes for strings optional as well.

```ruby
require 'hjson'

hjson =<<HJSON
{
  text: look ma, no quotes!

  # To make your life easy, put the next
  # value or comment on a new line.
  # It's also easier to read!
}
HJSON

Hjson.parse(hjson) #=> {"text"=>"look ma, no quotes!"}
```

### Escapes

You don't need to escape in unquoted strings.

```ruby
require 'hjson'

hjson = <<HJSON
{
  # write a regex without escaping the escape
  regex: ^\d*\.{0,1}\d+$

  # quotes in the content need no escapes
  inject: <div class="important"></div>

  # inside quotes, escapes work
  # just like in JSON
  escape: "\\\\ \n \t\\""
}
HJSON

Hjson.parse(hjson)
#=> {"regex"=>"^d*.{0,1}d+$",
 "inject"=>"<div class=\"important\"></div>",
 "escape"=>"\\ \n \t\""}
```

### Multiline

Hjson allows you to use `'''` for writing multiline strings.

```ruby
require 'hjson'

hjson =<<HJSON
{
  haiku:
    '''
    JSON I love you.
    But strangled is my data.
    This, so much better.
    '''
}
HJSON

Hjson.parse(hjson) #=> {"haiku"=>"JSON I love you.\nBut strangled is my data.\nThis, so much better."}
```

### Braces

You can omit the braces for the root object.

```ruby
require 'hjson'

hjson =<<HJSON
// this is a valid config file
joke: My backslash escaped!
HJSON

Hjson.parse(hjson) #=> {"joke"=>"My backslash escaped!"}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/namusyaka/hjson. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

