[![Gem Version](https://badge.fury.io/rb/active_record_in_cache.svg)](https://badge.fury.io/rb/active_record_in_cache)

# ActiveRecordInCache

`ActiveRecordInCache` provides a method to execute SQL while automatically caching.

## :package: Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_in_cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_in_cache

## :memo: Usage

Add a line to include `ActiveRecordInCache::Methods` as below:

```ruby
class ApplicationRecord < ActiveRecord::Base
  include ActiveRecordInCache::Methods

  self.abstract_class = true
end
```

You can call the `in_cache` method at the end of the chain.

```ruby
Article.all.in_cache
# SELECT MAX("articles"."updated_at") FROM "articles"
# SELECT "articles".* FROM "articles"
#=> #<ActiveRecord::Relation ...>

Article.all.in_cache
# SELECT MAX("articles"."updated_at") FROM "articles"
#=> #<ActiveRecord::Relation ...>
```

Automatically check `maximum(:updated_at)` and use the cache if it exists.

## :star: Implementation

The implementaiton is simple.

[lib/active_record_in_cache.rb](lib/active_record_in_cache.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sinsoku/active_record_in_cache. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveRecordInCache project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sinsoku/active_record_in_cache/blob/master/CODE_OF_CONDUCT.md).
