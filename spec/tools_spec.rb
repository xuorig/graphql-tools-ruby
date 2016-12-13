require 'spec_helper'

describe GraphQL::Tools do
  IDL = '
    type Query {
      shop: Shop!
    }

    type Shop {
      name: String!
      description: String
    }
  '

  class Query < GraphQL::Tools::Resolver
    def shop
      { name: 'MyShop', description: 'A Shop' }
    end
  end

  class Shop < GraphQL::Tools::Resolver
    def name
      object[:name]
    end

    def description
      object[:description]
    end
  end


  let(:resolvers) {
    {
      'Query' => Query,
      'Shop' => Shop
    }
  }

  it 'should generate an executable schema from an idl and resolvers hash' do
    schema = GraphQL::Tools.build_schema(IDL, resolvers: resolvers)
    result = schema.execute('query { shop { name description } }')

    expect(result).to eq({
      "data" => {
        "shop" => {
          "name" => "MyShop",
          "description" => "A Shop"
        }
      }
    })
  end
end
