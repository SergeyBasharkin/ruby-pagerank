require "./page_rank_builder.rb"
require "./page_rank.rb"
require "./small_page_rank.rb"

page_rank = PageRank.new(ARGV)
# page_rank = SmallPageRank.new(ARGV)
page_rank.calc_page_rank
page_rank.print
