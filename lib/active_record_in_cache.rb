# frozen_string_literal: true

require 'active_record_in_cache/version'

module ActiveRecordInCache
  module Methods
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Returns records while automatically caching with the SQL to execute and
      # the value of +maximum(:updated_at)+ as key.
      #
      #   Article.all.in_cache
      #   # SELECT MAX("articles"."updated_at") FROM "articles"
      #   # SELECT "articles".* FROM "articles"
      #   #=> [#<Article:0x0000000000000000>, ...]
      #
      #   Article.all.in_cache
      #   # SELECT MAX("articles"."updated_at") FROM "articles"
      #   #=> [#<Article:0x0000000000000000>, ...]
      #
      # === column
      #
      # If a column is passed, then uses this as the +maximum+ argument.
      #
      #   Article.all.in_cache(:published_at)
      #   # SELECT MAX("articles"."published_at") FROM "articles"
      #   # SELECT "articles".* FROM "articles"
      #   #=> [#<Article:0x0000000000000000>, ...]
      #
      # === options
      #
      # Supports the same arguments as +Rails.cache+.
      #
      #   Article.all.in_cache(expires_in: 5.minutes)
      #
      def in_cache(column = :updated_at, options = {}, &block)
        value = block_given? ? all.instance_exec(&block) : all.maximum(column)
        name = "#{all.to_sql}_#{value}"
        Rails.cache.fetch(name, options) { all.to_a }
      end
    end
  end
end
