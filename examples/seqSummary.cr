require "../src/BioSeq.cr"

BioSeq::FastaFile.new("otus.fa", BioSeq::Protein).each do |seq|
  print seq.to_fasta+"\n"
end
