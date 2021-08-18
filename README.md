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
require "mac_address"

mac = MacAddress::MAC.new("11:bb:cc:ee:44:55")

puts mac.bare # => 11bbccee4455

puts mac.eui # => 11-bb-cc-ee-44-55

puts mac.hex # => 11:bb:cc:ee:44:55

puts mac.dot # => 11bb.ccee.4455

puts mac.int # 19498294723669

puts mac.oui # => 11bbcc

puts mac.nic # => ee4455
```

## Contributing

1. Fork it (<https://github.com/automatico/mac-address/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Brad Searle](https://github.com/bwks) - creator and maintainer
