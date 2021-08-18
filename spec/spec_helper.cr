require "spec"
require "../src/mac_address"

def create_test_object(mac)
  MacAddress::MAC.new(mac)
end
