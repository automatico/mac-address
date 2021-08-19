module MacAddress
  private MAC_RE         = /^[0-9a-f]{12}$/i
  private BROADCAST_MAC  = "ffffffffffff"
  private MULTICAST_MAC  = "01005e"
  private HEX_TO_BIT_MAP = {
    '0' => "0000",
    '1' => "0001",
    '2' => "0010",
    '3' => "0011",
    '4' => "0100",
    '5' => "0101",
    '6' => "0110",
    '7' => "0111",
    '8' => "1000",
    '9' => "1001",
    'a' => "1010",
    'b' => "1011",
    'c' => "1100",
    'd' => "1101",
    'e' => "1110",
    'f' => "1111",
  }

  class MAC
    @bare_mac : String

    def initialize(address : String)
      @bare_mac = address.gsub(/[:\-\.\s]/, "").downcase
      unless MAC_RE.match(@bare_mac)
        raise MacAddress::InvalidMacError.new(@bare_mac)
      end
    end

    # Return the bare MAC address without any delimiters.
    # EG: 11aabbcdef33
    def bare
      @bare_mac
    end

    # Return the MAC address in EUI notation.
    # EG: 11-aa-bb-cd-ef-33
    def eui
      format(bare_mac: @bare_mac, delimiter: "-", spacing: 2)
    end

    # Return the MAC address in hex notation.
    # EG 11:aa:bb:cd:ef:33
    def hex
      format(bare_mac: @bare_mac, delimiter: ":", spacing: 2)
    end

    # Return the MAC address in dot notation.
    # EG: 11aa.bbcd.ef33
    def dot
      format(bare_mac: @bare_mac, delimiter: ".", spacing: 4)
    end

    # Return the MAC address as an integer.
    # EG: 11-aa-bb-cd-ef-33 == 19424992948019
    def int
      @bare_mac.to_u64(base: 16)
    end

    # Return the MAC address as an array of bits.
    # EG: "11-aa-bb-cd-ef-33"
    # => ["0001", "0001", "1010", "1010", "1011", "1011",
    #    "1100", "1101", "1110", "1111", "0011", "0011"]
    def bits
      bits = [] of String
      @bare_mac.each_char do |c|
        bits << HEX_TO_BIT_MAP[c]
      end
      bits
    end

    # Return the binary representation for a MAC.
    # EG: 11-aa-bb-cd-ef-33 => 100011010101010111011110011011110111100110011
    def binary
      bits.join
    end

    # Return the vendor portion of the MAC address.
    # EG: 11-aa-bb-cd-ef-33 => 11aabb
    def oui
      @bare_mac[0..5]
    end

    # Return the nic portion of the MAC address.
    # EG: 11-aa-bb-cd-ef-33 => cdef33
    def nic
      @bare_mac[6..11]
    end

    # Returns true if MAC is a broadcast address.
    def broadcast?
      bare == BROADCAST_MAC ? true : false
    end

    # Returns true if MAC is a multicast address.
    def multicast?
      oui == MULTICAST_MAC ? true : false
    end

    # Returns true if MAC is a unicast address.
    def unicast?
      broadcast? || multicast? ? false : true
    end

    # Returns the MAC address in an array of octets.
    # EG: 11-aa-bb-cd-ef-33 => ["11", "aa", "bb", "cd", "ef", "33"]
    def octets
      format(bare_mac: @bare_mac, delimiter: ":", spacing: 2).split(":")
    end

    private def format(bare_mac : String, delimiter : String, spacing : Int8)
      regex = /.{1,#{spacing}}/

      # .scan(re) returns an array of Regex::MatchData.
      # .map(&.[0]) returns the first match of each element as a string.
      # .join(delimiter) joins the array into a string.
      bare_mac.scan(regex).map(&.[0]).join(delimiter)
    end
  end
end
