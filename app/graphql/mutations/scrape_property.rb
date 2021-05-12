module Mutations
  class ScrapeProperty < BaseMutation
    argument :name, String, required: true

    type Types::PropertyType

    def resolve(name: nil)
      PropertyClass.new(name)
      # Property.find_by(name: name)
      Property.last
    end
  end
end



