require "../src/Bioseq"
require "option_parser"

input = ""
header = false
len = 60

ARGV.push("--help") if ARGV.empty?
OptionParser.parse! do |parser|
  parser.banner = "Usage: reformatFasta [options] --input <file>"
  parser.on("-i FILE", "--input=FILE", "Specifies input file") { |f| input = f }
  parser.on("-h", "--header", "keep sequence header") { header = true }

  parser.on("-l len", "--length=len", "Specifies line length (default 60)") { |l| len = l }
  parser.on("-e", "--help", "Show this help") { puts parser }
end

if input == ""
  STDERR.printf("reformatFasta: --input file is required\n")
else
  BioSeq::FastxFile.new(input).each do |seq|
    seq.definition = seq.entry_id if header
    print seq.to_fasta(len: len)
  end
end
