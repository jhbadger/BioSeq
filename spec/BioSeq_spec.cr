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
    s.to_fasta.should eq(">Foobar gene\nAAATTAAGGGGA")
  end
  it "should print as fasta with short lines" do
    (s.to_fasta len: 3).should eq(">Foobar gene\nAAA\nTTA\nAGG\nGGA")
  end
  it "should print as fasta with short lines" do
    s.to_fasta("Baz").should eq(">Baz\nAAATTAAGGGGA")
  end
end
