# BioSeq

Beginnings of a bioinformatics library for Crystal

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  BioSeq:
    github: jhbadger/BioSeq
```


## Usage


```crystal
require "BioSeq"

BioSeq::FastaFile.new("otus.fa").each do |seq|
  print seq.to_fasta
end
```


TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/BioSeq/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jhbadger](https://github.com/jhbadger) Jonathan Badger - creator, maintainer
