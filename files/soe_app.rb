#
# MCO application to check SOE
# Written by Brett Gray
# brett@puppet.com
#

module MCollective
  class Application
    class Soe_check < MCollective::Application
      description 'Update code base for an application'

      option  :resource_hash,
              :description => 'Hash of resources types and array of resource titles',
              :arguments   => ['-r RESOURCE_HASH','--resource_hash RESOURCE_HASH'],
              :type        => String,
              :required    => true

      def main
        mc = rpcclient('soe')

        output = mc.check_soe(:resource_hash => configuration[:resource_hash], :options => options)

        output.each do |result|
          puts JSON.pretty_generate(JSON.load(result[:data][:return_resources].to_json))
        end

        printrpcstats
      end
    end
  end
end
