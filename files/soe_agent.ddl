metadata    :name        => "soe",
            :description => "Checks SOE with Puppet's resource abstraction layer",
            :author      => "Beergeek",
            :license     => "Apache 2",
            :version     => "0.1.0",
            :url         => "https://github.com/beergeek/soe.git",
            :timeout     => 60

action "check_soe", :description => "Check the SOE from list of resources" do
  display :always

  input :resource_hash,
        :prompt       => "Resource hash of types with array of titles",
        :description  => "A hash of resource types with associated array of titles",
        :type         => :string,
        :maxlength    => 1000,
        :validation   => '.',
        :optional     => false


  output :return_resources,
         :description => "The values of the inspected resources",
         :display_as  => "Results"
end
