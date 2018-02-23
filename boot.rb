require "./page_rank_builder.rb"
matrixWriter = PageRankBuilder.new(ARGV[0],ARGV[1],ARGV[2])
matrixWriter.build
