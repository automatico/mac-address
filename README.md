# mac_address

Crystal library for working with MAC addresses.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     mac_address:
       github: automatico/mac-address
   ```

2. Run `shards install`

## Usage

```crystal
# Import the `mac_address` lib
require "mac_address"

# Create and instance of `MacAddress::MAC`
mac = MacAddress::MAC.new("11:bb:cc:ee:44:55")
```

### Methods

Return the bare MAC address without any delimiters.
```crystal
mac.bare # => "11bbccee4455"
```

Return the MAC address in EUI notation.
```crystal
mac.eui # => "11-bb-cc-ee-44-55"
```

Return the MAC address in hex notation.
```crystal
mac.hex # => "11:bb:cc:ee:44:55"
```

Return the MAC address in dot notation.
```crystal
mac.dot # => "11bb.ccee.4455"
```

Return the MAC address as an integer.
```crystal
mac.int # => 19498294723669
```

Return the MAC address as an array of bits.
```crystal
mac.bits # => ["0001", "0001", "1011", "1011", "1100", "1100", "1110", "1110", "0100", "0100", "0101", "0101"]
```

Return the binary representation for a MAC.
```crystal
mac.binary # => "000100011011101111001100111011100100010001010101"
```

Returns the MAC address in an array of octets.
```crystal
mac.octets # => ["11", "bb", "cc", "ee", "44", "55"]
```

Return the vendor portion of the MAC address.
```crystal
mac.oui # => 11bbcc
```

Return the nic portion of the MAC address.
```crystal
mac.nic # => ee4455
```

Returns `true` if MAC is a broadcast address.
```crystal
mac.broadcast? # => false
```

Returns `true` if MAC is a multicast address.
```crystal
mac.multicast? # => false
```

Returns `true` if MAC is a unicast address.
```crystal
mac.unicast? # => true
```

Convert MAC address into an IPv6 link local address.
```crystal
mac.ipv6_link_local # => fe80::13bb:ccff:feee:4455
```

Convert MAC address into an EUI-64 MAC address.
```crystal
mac.eui64 # => 13:bb:cc:ff:fe:ee:44:55
```

## Contributing

1. Fork it (<https://github.com/automatico/mac-address/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Brad Searle](https://github.com/bwks) - creator and maintainer
