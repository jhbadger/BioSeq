require "./BioSeq/*"

module BioSeq
  class Sequence
    def initialize(definition, seq)
      @entry_id = ""
      @definition = ""
      @seq = ""
      @entry_id = definition.split(" ").first
      @definition = definition
      @seq = seq
    end
    def entry_id
      @entry_id
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
      ">"+header+"\n"+@seq.gsub(Regex.new(".{1,#{len}}"), "\\0\n").chomp
    end
  end
  class Nucleic < Sequence
  end
  class Protein < Sequence
  end
  class FastaFile
    def initialize(filename)
      @file = File.new(filename)
    end
    def each
      seq = ""
      header = ""
      @file.each_line do |line|
        if line[0] == '>'
          if seq != ""
            yield Sequence.new(header, seq)
            seq = ""
            header = line[1..line.size].chomp
          end
        else
          seq += line.chomp.upcase
        end
      end
      yield Sequence.new(header, seq) if seq != ""
    end
  end
end
