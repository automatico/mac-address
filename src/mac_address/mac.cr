module MacAddress
  MAC_RE = /^[0-9a-f]{12}$/i

  class MAC
    @address : String

    getter address

    def initialize(@address)
      @address = @address.gsub(/[:\-\.]/, "")
    end

    def raw
      @address
    end

    def eui
      format(mac: @address, delimiter: "-", spacing: 2)
    end

    def unix
      format(mac: @address, delimiter: ":", spacing: 2)
    end

    def dot
      format(mac: @address, delimiter: ".", spacing: 4)
    end

    # format takes a raw mac and inserts a delimiter
    # every N number of spaces.
    private def format(mac : String, delimiter : String, spacing : Int8)
      re = /.{1,#{spacing}}/
      # .scan(re) returns an array of Regex::MatchData
      # .map(&.[0]) returns the first match of each element as a string
      # .join(delimiter) joins the array into a string
      mac.scan(re).map(&.[0]).join(delimiter)
    end

  end
end
