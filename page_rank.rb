class PageRank

  @matrix
  @page_rank
  @builder
  @d=0.85


  def initialize(arguments)
    @builder = PageRankBuilder.new(arguments[0],arguments[1],arguments[2])
    @matrix = @builder.build_matrix
    size = arguments[1]
    @page_rank = Array.new(size.to_i){|i| 1}
  end

  def print
    puts @page_rank
  end

  def multiply
    new_page_rank = Array.new
    5.times{ |i|
      @matrix.each_with_index{ |line, i|
        new_page_rank.push line.each_with_index.map{ |e, i| e*@page_rank[i] }.reduce(:+)
      }
      @page_rank = new_page_rank
      new_page_rank = Array.newl
    }
    @page_rank
  end

  def build_page_rank_array

  end

  def page_rank(ranks)
    (1-@d) + @d*(sum_rank(ranks))
  end

  def sum_rank(ranks)
    page_rank(ranks)
  end
end
