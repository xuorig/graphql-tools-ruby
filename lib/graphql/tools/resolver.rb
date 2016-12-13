module GraphQL
  module Tools
    class Resolver
      attr_reader :object, :arguments, :context

      def initialize(object, arguments, context)
        @object = object
        @arguments = arguments
        @context = context
      end
    end
  end
end
