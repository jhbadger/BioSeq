require "./BioSeq/*"
require "gzip"
require "Bzip"

module BioSeq
  class Sequence
    getter entry_id
    getter seq
    getter qual
    getter definition
    setter seq
    setter qual
    setter definition
    def initialize(definition, seq, qual = "")
      @entry_id = ""
      @definition = ""
      @seq = ""
      @qual = qual
      @entry_id = definition.split(" ").first
      @definition = definition
      @seq = seq
    end
    def size
      @seq.size
    end
    def to_fasta(header=@definition, len=60)
      ">"+header+"\n"+@seq.gsub(Regex.new(".{1,#{len}}"), "\\0\n").chomp+"\n"
    end
    def to_RNA
      Sequence.new(@definition, @seq.gsub("T","U"))
    end
    def to_DNA
      Sequence.new(@definition, @seq.gsub("U","T"))
    end
    def reverse_complement
      rv = ""
      @seq.size.times do |i|
        c = @seq[@seq.size - i - 1]
        if c == 'A'
          rv += 'T'
        elsif c == 'T' || c=='U'
          rv += 'A'
        elsif c == 'G'
          rv += 'C'
        elsif c == 'C'
          rv += 'G'
        else
          rv += 'N'
        end
      end
      Sequence.new(@definition, rv)
    end
    def gc_percent
      100*(@seq.count("GC"))/@seq.size
    end
    def translate(code=1)
      codes = ["FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG"]
      codons = ["TTT", "TTC", "TTA", "TTG", "TCT", "TCC", "TCA", "TCG", "TAT",
                "TAC", "TAA", "TAG", "TGT", "TGC", "TGA", "TGG", "CTT", "CTC",
                "CTA", "CTG", "CCT", "CCC", "CCA", "CCG", "CAT", "CAC", "CAA",
                "CAG", "CGT", "CGC", "CGA", "CGG", "ATT", "ATC", "ATA", "ATG",
                "ACT", "ACC", "ACA", "ACG", "AAT", "AAC", "AAA", "AAG", "AGT",
                "AGC", "AGA", "AGG", "GTT", "GTC", "GTA", "GTG", "GCT", "GCC",
                "GCA", "GCG", "GAT", "GAC", "GAA", "GAG", "GGT", "GGC", "GGA",
                "GGG"]
      pseq = ""
      @seq.upcase.gsub("U","T").chars.each_slice(3) do |c|
        aanum = codons.index c.join
        if aanum
          pseq += codes[code - 1][aanum]
        else
          pseq += "X"
        end
      end
      Sequence.new(@definition, pseq)
    end
    def to_fastq(header=@definition)
      "@"+header+"\n"+@seq+"\n"+"+\n"+@qual+"\n"
    end
  end
  class FastxFile
    def initialize(filename, fastq = false)
      if filename.includes?(".gz")
        @file = Gzip::Reader.new(filename)
      elsif filename.includes?(".bz2")
        @file = Bzip::Reader.new(filename) 
      else
        @file = File.new(filename)
      end
      @fastq = fastq
      @line_count = 0
    end
    def next
      each do |seq|
        @line_count += 1
        return seq
      end
    end
    def each
      seq = ""
      header = ""
      qual = ""
      @file.each_line do |line|
        if line[0] == '>' || (@line_count % 4 == 0 && @fastq)
          if (!@fastq && seq != "") || (@fastq && qual != "")
            yield Sequence.new(header, seq, qual)
            seq = ""
            qual = ""
	  end
          header = line[1..line.size].chomp
        elsif (@fastq && @line_count % 4 == 1) || !@fastq
          seq += line.chomp.upcase
        elsif (@fastq && @line_count % 4 == 3)
          qual += line.chomp.upcase
        end
        @line_count += 1
      end
      yield Sequence.new(header, seq, qual) if seq != ""
    end
  end
end
