class ParallelPageRank < PageRank
  def calc_page_rank
    threads = []
    10.times{
      new_page_rank = Array.new
      @matrix.each_with_index { |line, i|
        threads << Thread.new(line, i) do |l_p, i_p|
          Thread.current["i"] = i_p
          Thread.current["p_r"] = page_rank(l_p)
        end
      }
      threads.each { |t|
        t.join
        @page_rank[t["i"]] = t["p_r"]
      }
    }
  end
end
