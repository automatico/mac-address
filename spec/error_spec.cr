require "./spec_helper"

describe "MacAddress::MacAddressError" do
  it "generates error" do
    expect_raises(MacAddress::MacAddressError) do
      create_test_object("1111")
    end
  end
end
