# Cbloom

Sharded Bloom Filter for internal use.

## Installation

`shards build --release`

## Usage

```
Usage: cbloom [arguments]
    -d PATH, --directory=PATH        Path to directory where bitmaps are stored
    -s INT, --slice=INT              Number of bloom filter slices
    -e FLOAT, --probability=FLOAT    Probability of false positives
    -i INT, --item=INT               Max number of items
    -p INT, --flush=INT              Port for HTTP Server
    -h, --help                       Show this help
```

**Run**

```sh
./bin/cbloom -d ./bitmaps -s 5 -i 1000000 -e 0.01 -p 2023
```

**Call**

```sh
curl http://localhost:2023/get
```

## Contributors

- [creadone](https://github.com/your-github-user) - creator and maintainer
