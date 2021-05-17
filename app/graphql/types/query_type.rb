module Types
  class QueryType < Types::BaseObject

    field :properties, [Types::PropertyType], null: false do
      description "Returns list of properties"
      argument :name, String, required: true
      argument :limit, Integer, required: true
      argument :offset, Integer, required: true
    end

    def properties(**args)
		Property.where('name ILIKE ?', '%' + args[:name] + '%').limit(args[:limit]).offset(args[:offset])				
    end

  end
end



