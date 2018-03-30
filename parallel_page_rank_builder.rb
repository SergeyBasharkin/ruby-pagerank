class ParallelPageRankBuilder < PageRankBuilder
  def build_small_matrix
    @small_matrix = Array.new
    threads = []
    @hrefs.each_with_index { |href, i|
      threads << Thread.new(href) do |url|
        line = getLine(url)
        line.each_with_index { |count, j|
          matrix_node = MatrixNode.new(i, j, count, href, @hrefs[j])
          @small_matrix.push(matrix_node) if count != 0
        }
      end
    }
    threads.each { |thr| thr.join }
    @small_matrix
  end

  def build_matrix
    @matrix = Array.new(Array.new)
    threads = []
    @hrefs.each_with_index { |href, i|
      threads << Thread.new(href, i) do |url, i_thread|
        @matrix[i_thread] = getLine(url)
      end
    }
    threads.each { |thr| thr.join }
    @hrefs.size.times {|i| @matrix[i][i] = 0 }
    @matrix
  end
end
