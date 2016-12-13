require "graphql/tools/version"
require "graphql/tools/resolver"
require "graphql/tools/resolve_attacher"

module GraphQL
  module Tools
    def self.build_schema(idl, resolvers:)
      schema = GraphQL::Schema::BuildFromDefinition.from_definition(idl)
      ResolveAttacher.new(schema, resolvers: resolvers).attach_resolvers!
      schema
    end
  end
end
