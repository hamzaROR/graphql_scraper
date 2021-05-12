module Types
  class MutationType < Types::BaseObject
    # TODO: remove me

    field :scrape_property, mutation: Mutations::ScrapeProperty
        
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
