require "./spec_helper"

describe MacAddress::MAC do
  it "is created" do
    mac = create_test_object("1111.2222.3333")
    mac.should_not be_nil
  end

  it "is bare" do
    macs = [
      "1111.2222.3333",
      "11-11-22-22-33-33",
      "11:11:22:22:33:33",
      "111122223333",
    ]
    macs.each do |m|
      mac = create_test_object(m)
      mac.bare.should eq("111122223333")
    end
  end

  it "is eui" do
    mac = create_test_object("1111.2222.3333")
    mac.eui.should eq("11-11-22-22-33-33")
  end

  it "is dot" do
    mac = create_test_object("1111.2222.3333")
    mac.dot.should eq("1111.2222.3333")
  end

  it "is hex" do
    mac = create_test_object("1111.2222.3333")
    mac.hex.should eq("11:11:22:22:33:33")
  end

  it "is int" do
    mac = create_test_object("1111.2222.3333")
    mac.int.should eq(18765284782899)
  end

  it "is oui" do
    mac = create_test_object("1111.2222.3333")
    mac.oui.should eq("111122")
  end

  it "is host" do
    mac = create_test_object("1111.2222.3333")
    mac.host.should eq("223333")
  end

  it "is broadcast" do
    mac = create_test_object("ff:ff:ff:ff:ff:ff")
    mac.is_broadcast?.should eq(true)
  end

  it "is not broadcast" do
    mac = create_test_object("1111.2222.3333")
    mac.is_broadcast?.should eq(false)
  end
end
