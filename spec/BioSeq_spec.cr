require "./spec_helper"

describe BioSeq do
  s = BioSeq::Nucleic.new("Foobar gene","AAATTAAGGGGA")
  pep = BioSeq::Protein.new("Qux protein","MTCSSWLPRRD")
  it "entry_id is first word of definition" do
    s.entry_id.should eq("Foobar")
  end
  it "length should be 12" do
    s.size.should eq(12)
  end
  it "type of s is Nucleic" do
    s.type.should eq(BioSeq::Nucleic)
  end
  it "type of pep is Protein" do
    pep.type.should eq(BioSeq::Protein)
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
    f = BioSeq::Nucleic.new("Foo","GGG")
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
    s.translate.should eq("K")
  end
end
