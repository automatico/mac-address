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
  private BIT_TO_HEX_MAP = {
    "0000" => "0",
    "0001" => "1",
    "0010" => "2",
    "0011" => "3",
    "0100" => "4",
    "0101" => "5",
    "0110" => "6",
    "0111" => "7",
    "1000" => "8",
    "1001" => "9",
    "1010" => "a",
    "1011" => "b",
    "1100" => "c",
    "1101" => "d",
    "1110" => "e",
    "1111" => "f",
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
    def bare : String
      @bare_mac
    end

    # Return the MAC address in EUI notation.
    # EG: 11-aa-bb-cd-ef-33
    def eui : String
      format(bare_mac: @bare_mac, delimiter: "-", spacing: 2)
    end

    # Return the MAC address in hex notation.
    # EG 11:aa:bb:cd:ef:33
    def hex : String
      format(bare_mac: @bare_mac, delimiter: ":", spacing: 2)
    end

    # Return the MAC address in dot notation.
    # EG: 11aa.bbcd.ef33
    def dot : String
      format(bare_mac: @bare_mac, delimiter: ".", spacing: 4)
    end

    # Return the MAC address as an integer.
    # EG: 11-aa-bb-cd-ef-33 == 19424992948019
    def int : UInt64
      @bare_mac.to_u64(base: 16)
    end

    # Return the MAC address as an array of bits.
    # EG: "11-aa-bb-cd-ef-33"
    # => ["0001", "0001", "1010", "1010", "1011", "1011",
    #    "1100", "1101", "1110", "1111", "0011", "0011"]
    def bits : Array(String)
      bits = [] of String
      @bare_mac.each_char do |c|
        bits << HEX_TO_BIT_MAP[c]
      end
      bits
    end

    # Return the binary representation for a MAC.
    # EG: 11-aa-bb-cd-ef-33 => 100011010101010111011110011011110111100110011
    def binary : String
      bits.join
    end

    # Returns the MAC address in an array of octets.
    # EG: 11-aa-bb-cd-ef-33 => ["11", "aa", "bb", "cd", "ef", "33"]
    def octets : Array(String)
      hex.split(":")
    end

    # Return the vendor portion of the MAC address.
    # EG: 11-aa-bb-cd-ef-33 => 11aabb
    def oui : String
      @bare_mac[0..5]
    end

    # Return the nic portion of the MAC address.
    # EG: 11-aa-bb-cd-ef-33 => cdef33
    def nic : String
      @bare_mac[6..11]
    end

    # Returns true if MAC is a broadcast address.
    def broadcast? : Bool
      @bare_mac == BROADCAST_MAC ? true : false
    end

    # Returns true if MAC is a multicast address.
    def multicast? : Bool
      oui == MULTICAST_MAC ? true : false
    end

    # Returns true if MAC is a unicast address.
    def unicast? : Bool
      broadcast? || multicast? ? false : true
    end

    # Returns the MAC address as an IPv6 link local address.
    # EG: 11-aa-bb-cd-ef-33 => fe80::13aa:bbff:fecd:ef33
    # TODO: Add description on the conversion process.
    def ipv6_link_local : String
      formatted = format(bare_mac: ul_inverted, delimiter: ":", spacing: 4)
      "fe80::#{formatted}"
    end

    # Returns an EUI-48 MAC address as an EUI-64 MAC address.
    # EG: 00:15:2b:e4:9b:60 => 02:15:2b:ff:fe:e4:9b:60
    # TODO: Add description on the conversion process.
    # http://www.faqs.org/rfcs/rfc2373.html
    #
    # Example MAC: 00:15:2b:e4:9b:60
    #
    # Step #1: Split the MAC address in the middle:
    # 00:15:2b <==> e4:9b:60
    #
    # Step #2: Insert FF:FE in the middle:
    # 00:15:2b:FF:FE:e4:9b:60
    #
    # Step #3: Convert the first eight bits to binary:
    # 00 -> 00000000
    #
    # Step #4: Invert the 7th bit:
    # 00000000 -> 00000010
    #
    # Step #5: Convert these first eight bits back into hex:
    # 00000010 -> 02, which yields an EUI-64 address of 02:15:2B:FF:FE:e4:9b:60
    def eui64 : String
      format(bare_mac: ul_inverted, delimiter: ":", spacing: 2)
    end

    # Returns a MAC address spaced and delimited via
    # the defined paramters.
    private def format(bare_mac : String, delimiter : String, spacing : Int8) : String
      regex = /.{1,#{spacing}}/

      # .scan(re) returns an array of Regex::MatchData.
      # .map(&.[0]) returns the first match of each element as a string.
      # .join(delimiter) joins the array into a string.
      bare_mac.scan(regex).map(&.[0]).join(delimiter)
    end

    # Returns a MAC address with the Universal/Local (U/L)
    # Bit inverted. The U/L bit is the 7th but in the first
    # octet.
    private def ul_inverted
      the_bits = bits
      the_octets = octets

      flipped = [] of Int8
      the_bits[1].each_char_with_index do |c, i|
        if i == 2
          if c.to_i8 == 0
            flipped << 1
          else
            flipped << 0
          end
        else
          flipped << c.to_i8
        end
      end
      "#{BIT_TO_HEX_MAP[the_bits[0]]}#{BIT_TO_HEX_MAP[flipped.join]}#{the_octets[1]}#{the_octets[2]}fffe#{the_octets[3]}#{the_octets[4]}#{the_octets[5]}"
    end
  end
end
