require "./page_rank_builder.rb"
require "./page_rank.rb"
page_rank = PageRank.new(ARGV)
page_rank.multiply
page_rank.print
