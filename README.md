# Cbloom

Sharded Bloom Filter with hash generation for internal use.

## Installation

`shards install & shards build --release`

## Usage

```
Usage: cbloom [arguments]
    -d PATH, --directory=PATH        Path to directory where bitmaps are stored
    -s INT, --slice=INT              Number of bloom filter slices
    -e FLOAT, --probability=FLOAT    Probability of false positives
    -i INT, --item=INT               Max number of items
    -p INT, --port=INT               Port for HTTP Server
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

## Load test

On Mac mini (2018) with 3,6 GHz Quad-Core Intel Core i3 and 8 GB 2667 MHz DDR4

```
hey -n 1000000 -c 50 -m GET http://localhost:2023

Summary:
  Total:	24.7437 secs
  Slowest:	0.0316 secs
  Fastest:	0.0000 secs
  Average:	0.0012 secs
  Requests/sec:	40414.2646

  Total data:	14000000 bytes
  Size/request:	14 bytes

Response time histogram:
  0.000 [1]	|
  0.003 [996202]	|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.006 [3727]	|
  0.010 [8]	|
  0.013 [25]	|
  0.016 [28]	|
  0.019 [1]	|
  0.022 [3]	|
  0.025 [0]	|
  0.028 [2]	|
  0.032 [3]	|


Latency distribution:
  10% in 0.0008 secs
  25% in 0.0010 secs
  50% in 0.0011 secs
  75% in 0.0015 secs
  90% in 0.0017 secs
  95% in 0.0019 secs
  99% in 0.0029 secs

Details (average, fastest, slowest):
  DNS+dialup:	0.0000 secs, 0.0000 secs, 0.0316 secs
  DNS-lookup:	0.0000 secs, 0.0000 secs, 0.0070 secs
  req write:	0.0000 secs, 0.0000 secs, 0.0024 secs
  resp wait:	0.0012 secs, 0.0000 secs, 0.0313 secs
  resp read:	0.0000 secs, 0.0000 secs, 0.0206 secs

Status code distribution:
  [200]	1000000 responses
```

## Contributors

- [creadone](https://github.com/your-github-user) - creator and maintainer
