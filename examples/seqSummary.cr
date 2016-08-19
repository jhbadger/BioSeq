require "../src/Bioseq"
require "option_parser"

input = ""
total = false

ARGV.push("--help") if ARGV.empty?
OptionParser.parse! do |parser|
  parser.banner = "Usage: reformatFasta [options] --input <file>"
  parser.on("-i FILE", "--input=FILE",
            "Specifies input file") { |f| input = f }
  parser.on("-t", "--total",
            "summarize over all seqs") { |t| total = true }
  parser.on("-h", "--help", "Show this help") { puts parser }
end

tgc = 0
tat = 0
tambig = 0
tsize = 0
tcount = 0
if input == ""
  STDERR.printf("seqSummary: --input file is required\n")
else
  BioSeq::FastaFile.new(input).each do |seq|
    gc =  seq.seq.count("GCgc")
    at =  seq.seq.count("ATUatu")
    ambig = seq.seq.count("NRYWSnryws")
    size = seq.size
    if total
      tgc += gc
      tat += at
      tambig += ambig
      tsize += size
      tcount += 1
    else
      printf("---%s---\n", seq.definition)
      printf("Length: %d (%.1f megabases)\n", size, size / 1.0e6)
      printf("%% Ambiguous %d%%\n", ambig*100/ size)
      printf("GC:     %d%%\n", gc*100/size)
    end
  end
  if total
    printf("---%s: %d---\n", "Total sequences", tcount)
    printf("Average Length: %d (%.1f megabases)\n", tsize/tcount,
           (tsize/tcount) / 1.0e6)
    printf("%% Ambiguous %d%%\n", tambig*100/tsize)
    printf("GC:     %d%%\n", tgc*100/tsize)
  end
end


