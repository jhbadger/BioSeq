#!/usr/bin/env ruby

require "../src/Bioseq"
require "option_parser"

input = ""
header = false

OptionParser.parse! do |parser|
  parser.banner = "Usage: reformatFasta [options] --input <file>"
  parser.on("-i FILE", "--input=FILE", "Specifies input file") { |f| input = f }
  parser.on("-h", "--header", "keep sequence header") { header = true }

  parser.on("-e", "--help", "Show this help") { puts parser }
end

if input == ""
  STDERR.printf("reformatFasta: --input file is required\n")
else
  BioSeq::FastaFile.new(input).each do |seq|
    print seq.to_fasta
  end
end
