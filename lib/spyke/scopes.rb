require 'spyke/relation'
require 'spyke/scope_registry'

module Spyke
  module Scopes
    extend ActiveSupport::Concern

    module ClassMethods
      delegate :where, :build, to: :all

      def all
        if current_scope
          current_scope.clone
        else
          Relation.new(self, uri: uri)
        end
      end

      def scope(name, code)
        define_singleton_method name, code
      end

      def current_scope=(scope)
        ScopeRegistry.set_value_for(:current_scope, name, scope)
      end

      def current_scope
        ScopeRegistry.value_for(:current_scope, name)
      end
    end

    private

      def query
        self.class.all
      end
  end
end
