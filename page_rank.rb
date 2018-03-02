class PageRank

  @matrix
  @page_rank
  @builder
  @d


  def initialize(arguments)
    @builder = PageRankBuilder.new(arguments[0],arguments[1],arguments[2])
    @matrix = @builder.build_matrix
    size = arguments[1]
    @page_rank = Array.new(size.to_i){|i| 1}
    @d = 0.85
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
      new_page_rank = Array.new
    }
    @page_rank
  end

  def calc_page_rank
      @matrix.each_with_index { |line, i|
        @page_rank[i] = page_rank(line)
      }
  end

  def page_rank(ranks)
    (1-@d) + @d*(self.sum_rank(ranks))
  end

  def sum_rank(ranks)
    rn = Array.new
    ranks.each_with_index{ |r,i|
      if r != 0
        rn.push @page_rank[i] / r
      else
        rn.push 0
      end
     }
     rn.sum
  end
end
