module Types
  class QueryType < Types::BaseObject

    field :properties, PropertyType, null: true do
      description "Returns list of properties"
      argument :name, String, required: true
    end

    def properties(name:)
      Property.find_by(name: name)
    end

  end
end
