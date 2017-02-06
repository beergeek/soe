require 'puppet'

module MCollective
  module Agent
    class Soe<RPC::Agent

      action "check_soe" do
        return_resources = Array.new
        eval(request[:resource_hash]).each do |resource_type, resource_title_array|
          typeobj = ::Puppet::Type.type(resource_type) or reply.fail!(reply[:type] = "Could not find type #{resource_type}")
          if typeobj
            resource_title_array.each do |resource_title|
              resource = ::Puppet::Resource.indirection.find([resource_type, resource_title].join('/'))
              result = resource.respond_to?(:prune_parameters) ?
                resource.prune_parameters.to_data_hash : resource.to_data_hash
              return_resources << result
            end
          end
        end
        reply[:return_resources] = JSON.load(return_resources.to_json)
      end
    end
  end
end
