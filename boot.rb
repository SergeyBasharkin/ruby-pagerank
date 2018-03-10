require "./page_rank_builder.rb"
require "./page_rank.rb"
page_rank = PageRankBuilder.new(ARGV)
page_rank.print_to_file
page_rank.print
