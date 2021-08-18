module MacAddress
  MAC_RE = /^[0-9a-f]{12}$/i

  class MAC
    @bare_mac : String

    def initialize(address : String)
      @bare_mac = address.gsub(/[:\-\.]/, "")
      unless MacAddress::MAC_RE.match(@bare_mac)
        raise MacAddress::InvalidMacError.new(@bare_mac)
      end
    end

    # Return the bare MAC address.
    def bare
      @bare_mac
    end

    # Return the MAC address in EUI notation.
    def eui
      format(bare_mac: @bare_mac, delimiter: "-", spacing: 2)
    end

    # Return the MAC address in hex notation.
    def hex
      format(bare_mac: @bare_mac, delimiter: ":", spacing: 2)
    end

    # Return the MAC address in dot notation.
    def dot
      format(bare_mac: @bare_mac, delimiter: ".", spacing: 4)
    end

    # Return the MAC address as an integer.
    def int
      @bare_mac.to_u64(base: 16)
    end

    # Return the vendor portion of the MAC address.
    def oui
      @bare_mac[0..5]
    end

    # Return the host portion of the MAC address.
    def host
      @bare_mac[6..11]
    end

    def is_broadcast?
      bare == "ffffffffffff" ? true : false
    end

    def is_multicast?
      oui == "01005e" ? true : false
    end

    def is_unicast?
      is_broadcast? || is_multicast? ? false : true
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
