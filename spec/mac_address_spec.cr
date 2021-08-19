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

  it "is nic" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.nic.should eq("cdef33")
  end

  it "is broadcast" do
    mac = create_test_object("ff:ff:ff:ff:ff:ff")
    mac.broadcast?.should eq(true)
  end

  it "is not broadcast" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.broadcast?.should eq(false)
  end

  it "is multicast" do
    mac = create_test_object("01:00:5e:ff:ff:ff")
    mac.multicast?.should eq(true)
  end

  it "is not multicast" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.multicast?.should eq(false)
  end

  it "is unicast" do
    mac = create_test_object("11AA.bbcD.EF33")
    mac.unicast?.should eq(true)
  end

  it "is not unicast" do
    macs = [
      "01:00:5e:ff:ff:ff",
      "ff:ff:ff:ff:ff:ff",
    ]
    macs.each do |m|
      mac = create_test_object(m)
      mac.unicast?.should eq(false)
    end
  end

  it "is an array of octets" do
    mac = create_test_object("11-aa-bb-cd-ef-33")
    mac.octets.should eq(["11", "aa", "bb", "cd", "ef", "33"])
  end

  it "is binary" do
    mac = create_test_object("11-aa-bb-cd-ef-33")
    mac.binary.should eq("000100011010101010111011110011011110111100110011")
  end

  it "is an array of bits" do
    mac = create_test_object("11-aa-bb-cd-ef-33")
    mac.bits.should eq(["0001", "0001", "1010", "1010", "1011", "1011", "1100", "1101", "1110", "1111", "0011", "0011"])
  end

  it "is IPv6 link-local address" do
    macs = [
      {have: "11-aa-bb-cd-ef-33", want: "fe80::13aa:bbff:fecd:ef33"},
      {have: "ab:cd:ef:12:34:56", want: "fe80::a9cd:efff:fe12:3456"},
      {have: "bc:cd:ef:12:34:56", want: "fe80::becd:efff:fe12:3456"},
    ]
    macs.each do |m|
      mac = create_test_object(m[:have])
      mac.ipv6_link_local.should eq(m[:want])
    end
  end
end
