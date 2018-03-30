require "./page_rank_builder.rb"
require "./page_rank.rb"
require "./small_page_rank.rb"
require "./parallel_page_rank.rb"
require "./parallel_page_rank_builder.rb"

arguments = ARGV

begin_time = Time.now
page_rank = PageRank.new(ARGV, ParallelPageRankBuilder.new(arguments[0],arguments[1],arguments[2],false))
# page_rank = SmallPageRank.new(ARGV,PageRankBuilder.new(arguments[0], arguments[1], arguments[2], true))
page_rank.calc_page_rank
page_rank.print
puts Time.now - begin_time
# builder = ParallelPageRankBuilder.new(arguments[0],arguments[1],arguments[2],false)
# # builder = PageRankBuilder.new(arguments[0],arguments[1],arguments[2],false)
# mtr = builder.build_matrix
#
# mtr.each {|node|
#   puts node.to_s
# }
