module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :properties, PropertyType, null: true do
      description "Returns list of properties"
      argument :name, String, required: true
    end

    def properties(name:)
      Property.find_by(name: name)
    end



    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
