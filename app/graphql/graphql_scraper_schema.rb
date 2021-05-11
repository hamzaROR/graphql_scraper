require 'types/mutation_type'
class GraphqlScraperSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
