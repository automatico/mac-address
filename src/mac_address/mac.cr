module MacAddress
  MAC_RE = /^[0-9a-f]{12}$/i

  class MAC
    @bare_mac : String

    def initialize(address : String)
      @bare_mac = address.gsub(/[:\-\.]/, "")
      unless MacAddress::MAC_RE.match(@bare_mac)
        raise MacAddress::InvalidMacAddress.new(@bare_mac)
      end
    end

    def bare
      @bare_mac
    end

    def eui
      format(bare_mac: @bare_mac, delimiter: "-", spacing: 2)
    end

    def unix
      format(bare_mac: @bare_mac, delimiter: ":", spacing: 2)
    end

    def dot
      format(bare_mac: @bare_mac, delimiter: ".", spacing: 4)
    end

    private def format(bare_mac : String, delimiter : String, spacing : Int8)
      re = /.{1,#{spacing}}/
      # .scan(re) returns an array of Regex::MatchData
      # .map(&.[0]) returns the first match of each element as a string
      # .join(delimiter) joins the array into a string
      bare_mac.scan(re).map(&.[0]).join(delimiter)
    end

  end
end
