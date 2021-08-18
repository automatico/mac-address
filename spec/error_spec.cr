require "./spec_helper"

describe "MacAddress::InvalidMacError" do
  it "generates error" do
    expect_raises(MacAddress::InvalidMacError) do
      create_test_object("1111")
    end
  end
end
