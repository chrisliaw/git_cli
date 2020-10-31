# GitCli

This project is aimed to create the interfacing to GIT via the Command Line Interface (CLI). This is due to the CLI is always the latest version while library is lacking behind. Furthermore, library for Ruby or Java might not be coming in so soon, being later should be a better in keeping up the changes.

Hence the interfacing with the CLI seems the better way to do that.

This codes are tested using git version 2.25.1, Linux x86\_64 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gvcs'
gem 'git_cli'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gvcs
    $ gem install git_cli

## Usage

This gem is intended to be the provider for Gvcs generic API. It is used together with [Gvcs](https://github.com/chrisliaw/gvcs).

Example usage:

```ruby
require 'gvcs'
# require git_cli after gvcs because git_cli will initialize the gvcs classes with appropriate methods
require 'git_cli'

# Loading the provider. 
# in this case is git_cli
vcs = Gvcs::Vcs.new
vcs.init(path) # init workspace at the given path

@ws = Gvcs::Workspace.new(vcs, path)
# @ws now can invoke all supported git operations 

```
 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chrisliaw/git_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/chrisliaw/git_cli/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the GitCli project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/chrisliaw/git_cli/blob/master/CODE_OF_CONDUCT.md).
