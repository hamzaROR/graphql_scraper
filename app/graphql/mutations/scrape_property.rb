module Mutations
  class ScrapeProperty < BaseMutation
    argument :name, String, required: true

    type Types::PropertyType

    def resolve(name: nil)
		begin
			PropertyClass.new(name)
			Property.find_by(name: property_name)
		rescue Exception
			raise
		end
    end
  end
end



