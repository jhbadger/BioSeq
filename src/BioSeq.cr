require "./BioSeq/*"
require "gzip"

module BioSeq
  class Sequence
    getter entry_id
    getter seq
    getter definition
    setter seq
    setter definition
    def initialize(definition, seq, qual)
      @entry_id = ""
      @definition = ""
      @seq = ""
      @qual = ""
      @entry_id = definition.split(" ").first
      @definition = definition
      @seq = seq
    end
    def size
      @seq.size
    end
    def type
      if @seq.count("ATGCRN") > @seq.size*0.9
        Nucleic
      else
        Protein
      end
    end
    def to_fasta(header=@definition, len=60)
      ">"+header+"\n"+@seq.gsub(Regex.new(".{1,#{len}}"), "\\0\n").chomp+"\n"
    end
  end
  class Nucleic < Sequence
    def to_RNA
      Nucleic.new(@definition, @seq.gsub("T","U"))
    end
    def to_DNA
      Nucleic.new(@definition, @seq.gsub("U","T"))
    end
    def gc_percent
      100*(@seq.count("GC"))/@seq.size
    end
  end
  class Fastq < Nucleic
    def to_fastq(header=@definition)
      "@"+header+"\n"+@seq+"\n"+"+\n"+@qual+"\n"
    end
  end
  class Protein < Sequence
  end
  class FastxFile
    def initialize(filename, type=Sequence)
      if filename.includes?(".gz")
        @file = Gzip::Reader.new(filename)
      else
        @file = File.new(filename)
      end
      @type = type
    end
    def each
      seq = ""
      header = ""
      if @type != Fastq
        @file.each_line do |line|
          if line[0] == '>'
            if seq != ""
              @type = Sequence.new(header, seq, "").type if @type==Sequence
              yield @type.new(header, seq, "")
              seq = ""
              header = line[1..line.size].chomp
            end
          else
            seq += line.chomp.upcase
          end
        end
        yield @type.new(header, seq, "") if seq != ""
      else
        count = 0
        qual = ""
        @file.each_line do |line|
          lnum = count % 4
          if lnum == 0
            header = line[1..line.size].chomp
          elsif lnum == 1
            seq = line.chomp
          elsif lnum == 3
            yield Fastq.new(header, seq, line) if seq != ""
          end
          count += 1
        end
      end
    end
  end
end
