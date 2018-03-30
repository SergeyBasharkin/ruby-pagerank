class PageRank
  def initialize(arguments, page_rank_builder)
    @builder = page_rank_builder
    @matrix = @builder.getMatrix
    size = arguments[1]
    @page_rank = Array.new(size.to_i){|i| 1}
    @d = 0.85
  end

  def print
    hrefs = @builder.getHrefs
    p_r_s = @page_rank.sort{ |x, y| y<=>x }
    @page_rank.each_with_index{ |e, i |
      i = p_r_s.index(e)
      p_r_s[i] = nil
      puts "[#{i.to_s}] #{e.to_s} -> #{hrefs[i]}"
    }
    @builder.print_to_file
  end

  def calc_page_rank
      10.times{
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
    init_ranks
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






















  def init_ranks
    sleep(0.00001)
  end
end
