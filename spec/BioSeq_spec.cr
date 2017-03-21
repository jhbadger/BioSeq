require "./spec_helper"

describe BioSeq do
  s = BioSeq::Sequence.new("Foobar gene","AAATTAAGGGGA")
  it "entry_id is first word of definition" do
    s.entry_id.should eq("Foobar")
  end
  it "length should be 12" do
    s.size.should eq(12)
  end
  it "should print as fasta" do
    s.to_fasta.should eq(">Foobar gene\nAAATTAAGGGGA\n")
  end
  it "should print as fasta with short lines" do
    (s.to_fasta len: 3).should eq(">Foobar gene\nAAA\nTTA\nAGG\nGGA\n")
  end
  it "should print as fasta with new header" do
    s.to_fasta("Baz").should eq(">Baz\nAAATTAAGGGGA\n")
  end
  it "should allow seq to be updated" do
    f = BioSeq::Sequence.new("Foo","GGG")
    f.seq = "AAA"
    f.to_fasta.should eq(">Foo\nAAA\n")
  end
  it "should convert DNA to RNA" do
    s.to_RNA.seq.should eq("AAAUUAAGGGGA")
  end
  it "should convert DNA to RNA to DNA" do
    s.to_RNA.to_DNA.seq.should eq(s.seq)
  end
  it "should compute gc percentage" do
    s.gc_percent.should eq(33)
  end
  it "should translate correctly" do
    s.translate.seq.should eq("KLRG")
  end
  it "should load the first and second Fasta sequences" do
     f = File.new("seq_tmp.fa","w")
     f.print(">seq1\nAAA\n>seq2\nTTT\n")
     f.close
     seq_iter = BioSeq::FastxFile.new("seq_tmp.fa") 
     s1 = seq_iter.next
     if !s1.nil?
       s1.seq.should eq("AAA")
     end
     s2 = seq_iter.next
     if !s2.nil?
       s2.seq.should eq("TTT")
     end
     File.delete("seq_tmp.fa")
  end
  it "should load the first and second Fastq sequences" do
     f = File.new("seq_tmp.fq","w")
     f.print("@seq1\nAAA\n+\n\HHH\n@seq2\nTTT\n+\nHHH\n")
     f.close
     seq_iter = BioSeq::FastxFile.new("seq_tmp.fq", fastq=true) 
     s1 = seq_iter.next
     if !s1.nil?
       s1.seq.should eq("AAA")
       s1.qual.should eq("HHH")
     end
     s2 = seq_iter.next
     if !s2.nil?
       s2.seq.should eq("TTT")
     end
     File.delete("seq_tmp.fq")
  end
  it "should reverse complement a sequence" do
    s = BioSeq::Sequence.new("Foo","AAAT")
    srev = s.reverse_complement
    srev.seq.should eq("ATTT")
  end
end
