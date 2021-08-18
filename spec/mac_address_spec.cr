require "./spec_helper"

describe MacAddress::MAC do
  it "is created" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.should_not be_nil
  end

  it "is bare" do
    macs = [
      "11AA.bbcD.EF33",
      "11-AA-bb-cD-EF-33",
      "11:AA:bb:cD:EF:33",
      "11AAbbcDEF33",
      " 11 AA bb cD EF 33 ",
    ]
    macs.each do |m|
      mac = create_test_object(m)
      mac.bare.should eq("11aabbcdef33")
    end
  end

  it "is eui" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.eui.should eq("11-aa-bb-cd-ef-33")
  end

  it "is dot" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.dot.should eq("11aa.bbcd.ef33")
  end

  it "is hex" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.hex.should eq("11:aa:bb:cd:ef:33")
  end

  it "is int" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.int.should eq(19424992948019)
  end

  it "is oui" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.oui.should eq("11aabb")
  end

  it "is host" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.host.should eq("cdef33")
  end

  it "is broadcast" do
    mac = create_test_object("ff:ff:ff:ff:ff:ff")
    mac.is_broadcast?.should eq(true)
  end

  it "is not broadcast" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.is_broadcast?.should eq(false)
  end

  it "is multicast" do
    mac = create_test_object("01:00:5e:ff:ff:ff")
    mac.is_multicast?.should eq(true)
  end

  it "is not multicast" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.is_multicast?.should eq(false)
  end

  it "is unicast" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.is_unicast?.should eq(true)
  end

  it "is not unicast" do
    macs = [
      "01:00:5e:ff:ff:ff",
      "ff:ff:ff:ff:ff:ff",
    ]
    macs.each do |m|
      mac = create_test_object(m)
      mac.is_unicast?.should eq(false)
    end
  end
end
