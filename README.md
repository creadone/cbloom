# Cbloom

Sharded Bloom Filter with hash generation for use on my internal project. Cbloom is cluster of 32bit Bloom filters that can be flushed on drive. It work through socket (see /lua/cbloom.lua). Cbloom is needed to quickly generate a large number of unique hashes and nothing else.

## Installation

`shards install & shards build --release`

## Usage

```
Usage: cbloom [arguments]
    -d PATH,  --directory=PATH       Path to directory where bitmaps are stored
    -s INT,   --shards=INT           Number of bloom filter shards
    -e FLOAT, --probability=FLOAT    Probability of false positives
    -i INT,   --item=INT             Max number of items
    -h,       --help                 Show this help
```

## Usage

**Run**
```sh
./bin/cbloom -d ./bitmaps -s 5 -i 1000000 -e 0.01
```

**Call**
```lua
local cbloom = require('cbloom')

cbloom.setup('/var/run/cbloom.sock')
print(cbloom.get())
```

## Contributors

- [creadone](https://github.com/creadone) - creator and maintainer
