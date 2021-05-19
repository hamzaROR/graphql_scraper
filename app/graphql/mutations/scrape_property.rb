module Mutations
  class ScrapeProperty < BaseMutation
    argument :name, String, required: true

    type Types::PropertyType

    def resolve(name: nil)
		begin
			scrapper_call = PropertyClass.new(name).call
			if scrapper_call[:success]
				property = scrapper_call[:property]
			else
   		      GraphQL::ExecutionError.new(scrapper_call[:msg])
			end
	    rescue Exception => e
	      GraphQL::ExecutionError.new("Error: #{e.message}")
	    end			
    end
  end
end



