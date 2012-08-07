require 'active_support/concern'

module OrmAdapter
  module ToAdapter
    extend ActiveSupport::Concern

    included do
      puts "INCLUDING!"
      def self.to_adapter
        @_to_adapter ||= self::OrmAdapter.new(self)
      end
    end
  end
end
