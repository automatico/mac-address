module MacAddress
  MAC_RE = /^[0-9a-f]{12}$/i

  class MAC
    @bare_mac : String

    def initialize(address : String)
      @bare_mac = address.gsub(/[:\-\.\s]/, "").downcase
      unless MacAddress::MAC_RE.match(@bare_mac)
        raise MacAddress::InvalidMacError.new(@bare_mac)
      end
    end

    # Return the bare MAC address.
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

    # Return the vendor portion of the MAC address.
    # EG: 11-aa-bb-cd-ef-33 == 11aabb
    def oui
      @bare_mac[0..5]
    end

    # Return the nic portion of the MAC address.
    # EG: 11-aa-bb-cd-ef-33 == cdef33
    def nic
      @bare_mac[6..11]
    end

    # Returns true if MAC is a broadcast address.
    def broadcast?
      bare == "ffffffffffff" ? true : false
    end

    # Returns true if MAC is a multicast address.
    def multicast?
      oui == "01005e" ? true : false
    end

    # Returns true if MAC is a unicast address.
    def unicast?
      broadcast? || multicast? ? false : true
    end

    # Returns the MAC address in an array of octets.
    def octets
      format(bare_mac: @bare_mac, delimiter: ":", spacing: 2).split(":")
    end

    private def format(bare_mac : String, delimiter : String, spacing : Int8)
      re = /.{1,#{spacing}}/

      # .scan(re) returns an array of Regex::MatchData.
      # .map(&.[0]) returns the first match of each element as a string.
      # .join(delimiter) joins the array into a string.
      bare_mac.scan(re).map(&.[0]).join(delimiter)
    end
  end
end
