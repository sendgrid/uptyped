# Uptyped

This gem enforces interface matching. When configured, any class that inherits
from something other than Object will have tests added to make sure that the public
class and instance methods match the parent class for naming and arity. This is done
through testing so that there is no need for running unnecessary code during production.

Please only use inheritance when it is truly appropriate.

## Installation

Add this line to your application's Gemfile:

    gem 'uptyped'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uptyped

## Usage

• Come up with a new name.
• Create testing for the shared context
• Improve configuration
• Allow for white-listing of classes?

## Contributing

1. Fork it ( https://github.com/[my-github-username]/uptyped/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
