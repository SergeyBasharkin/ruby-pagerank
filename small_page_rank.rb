class SmallPageRank
  def initialize(arguments, from_file = true)
    @builder = PageRankBuilder.new(arguments[0], arguments[1], arguments[2], true)
    @small_matrix = @builder.get_small_matrix
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
      puts "[#{i}] #{e.to_s} -> #{hrefs[i]}"
    }
    @builder.print_to_file_small_matrix
  end

  def calc_page_rank
      2.times{
        new_page_rank = Array.new
        line = Array.new
        i = 0
        while i < @builder.getHrefs.size do
          line = @small_matrix.select { |node|
              node.i.to_i == i
            }.map{ |node|
              node.j.to_i
            }
          unless line.empty?
            new_page_rank.push page_rank(line)
          else
            new_page_rank.push (1 - @d)
          end
          i+=1
        end
        @page_rank = new_page_rank
      }
  end

  def page_rank(ranks)
    (1-@d) + @d*(self.sum_rank(ranks))
  end

  def sum_rank(ranks)
    rn = Array.new
    ranks.each { |j|
      rn.push @page_rank[j] / 1
     }
     rn.sum
  end
end
