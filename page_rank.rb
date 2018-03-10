class PageRank

  @matrix
  @page_rank
  @builder
  @d


  def initialize(arguments, from_file = true)
    @builder = PageRankBuilder.new(arguments[0],arguments[1],arguments[2],false)
    @matrix = @builder.build_matrix()
    size = arguments[1]
    @page_rank = Array.new(size.to_i){|i| 1}
    @d = 0.85
  end

  def print
    hrefs = @builder.getHrefs
    @page_rank.each_with_index{ |e, i |
      puts e.to_s + " -> " + hrefs[i]
    }
  end

  def multiply
    new_page_rank = Array.new
    7.times{ |i|
      @matrix.each_with_index{ |line, i|
        new_page_rank.push line.each_with_index.map{ |e, i| e*@page_rank[i] }.reduce(:+)
      }
      @page_rank = new_page_rank
      new_page_rank = Array.new
    }
    @page_rank
  end

  def calc_page_rank

      2.times{

        new_page_rank = Array.new
        @matrix.each_with_index { |line, i|
          new_page_rank.push page_rank(line)
        }
        @page_rank = new_page_rank
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
