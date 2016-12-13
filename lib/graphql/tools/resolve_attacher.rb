module GraphQL
  module Tools
    class ResolveAttacher
      class MissingResolverError < StandardError; end

      def initialize(schema, resolvers:)
        @schema = schema
        @resolvers = resolvers
      end

      def attach_resolvers!
        root_types = [
          schema.query,
          schema.mutation,
          schema.subscription
        ].compact

        root_types.each do |root_type|
          attach_resolvers_on_type(root_type)
        end
      end

      def attach_resolvers_on_type(type)
        resolver_klass = resolvers[type.name]
        raise MissingResolverError unless resolver_klass

        type.fields.values.each do |field|
          attach_resolver_on_field(field, resolver_klass)

          field_type = field.type.unwrap
          if field_type.is_a?(GraphQL::ObjectType)
            attach_resolvers_on_type(field_type)
          end
        end
      end

      def attach_resolver_on_field(field, resolver_klass)
        field.resolve = lambda do |object, arguments, context|
          instance = resolver_klass.new(object, arguments, context)
          instance.public_send(field.name.to_sym)
        end
      end

      private

      attr_reader :schema, :resolvers
    end
  end
end
