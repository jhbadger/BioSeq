require "../src/BioSeq.cr"

BioSeq::FastaFile.new("otus.fa").each do |seq|
  print seq.to_fasta+"\n"
end
