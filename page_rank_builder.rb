require 'nokogiri'
require 'open-uri'
require './matrix_node.rb'

class PageRankBuilder
  def getHrefs
    @hrefs
  end

  def getMatrix
    @matrix
  end

  def get_small_matrix
    @small_matrix
  end

  def initialize(url = nil , count = 0, flag="1", small)
    @url = url
    if small
      unless File.exist?("small_#{@url.split("://")[1].split("/")[0]}")
        init(url, count, flag)
        build_small_matrix
      else
        build_small_matrix_from_file
      end
    else
      unless File.exist?(@url.split("://")[1].split("/")[0])
        init(url, count, flag)
        build_matrix
      else
        build_matrix_from_file
      end
    end
  end

  def init(url = nil , count = 0, flag="1")
    puts 'fetching..'
    html = open(url)
    puts 'done'

    puts 'parsing..'
    doc = Nokogiri::HTML(html)
    @hrefs = doc.css('a').to_a.uniq.delete_if{ |a|
        a["href"].nil? ||
        a["href"].match("/#") ||
        (flag==="1" &&
          (
            !a["href"].match?("(https|http)://"+@url.split("://")[1]+".*")
          )
        )
    }[0, count.to_i].map{ |link|
       link["href"]
    }
    @hrefs.map! {|a|
      if a.match("(https|http)://.*")
        a
      else
        url + a
      end
       }
    @hrefs[0] = url
  end

  def getLine(url)
    puts 'fetching.. '+ url
    html = open(url)
    puts 'done'

    puts 'parsing..'
    doc = Nokogiri::HTML(html)
    hrefs = doc.css('a').to_a.uniq.delete_if{ |a|
      a["href"].nil?
    }.map{ |link|
       link["href"]
    }
    line = Array.new
    @hrefs.each{ |link|
      if hrefs.include? link
        line.push 1
      else
        line.push 0
      end
    }
    line
  end

  def build_matrix_from_file
    lines = Array.new
    file = File.new(@url.split("://")[1].split("/")[0], "r")
    line = file.gets
    line.slice!("\n")
    line.slice!("[")
    line.slice!("]")
    hfs = line.split(",")
    hfs.map! {|e|
      e.slice!("\"")
      e.slice!("\"")
      e.slice!(" ")
      e
    }
    @hrefs = hfs
    while (line = file.gets)
      line.slice!("\n")
      line.slice!("[")
      line.slice!("]")
      arr = line.split(",")
      arr.map! { |e|
        e.slice!(" ")
        e.to_i
      }
       lines << arr
    end
    @matrix = lines
  end

  def build_matrix
    @matrix = Array.new(Array.new)
    @hrefs.each_with_index { |href, i| @matrix[i] = getLine(href) }
    @hrefs.size.times {|i| @matrix[i][i] = 0 }
    @matrix
  end

  def build_small_matrix
    @small_matrix = Array.new
    @hrefs.each_with_index { |href, i|
      line = getLine(href)
      line.each_with_index { |count, j|
        matrix_node = MatrixNode.new(i, j, count, href, @hrefs[j])
        @small_matrix.push(matrix_node) if count != 0
      }
    }
    @small_matrix
  end

  def build_small_matrix_from_file
    lines = Array.new
    file = File.new("small_#{@url.split("://")[1].split("/")[0]}", 'r')
    line = file.gets
    line.slice!("\n")
    line.slice!("[")
    line.slice!("]")
    hfs = line.split(",")
    hfs.map! {|e|
      e.slice!("\"")
      e.slice!("\"")
      e.slice!(" ")
      e
    }
    @hrefs = hfs
    @small_matrix = Array.new
    while (line = file.gets)
      nodes = line.split(";")
      nodes.map! { |node|
        node.split(": ")[1]
      }
      node = MatrixNode.new(nodes[0], nodes[1], nodes[2], nodes[3], nodes[4])
      @small_matrix.push(node)
    end
    @small_matrix
  end

  def print_to_file
    f = File.new(@url.split("://")[1].split("/")[0], 'w')
    f.write(@hrefs.to_s)
    f.write("\n")
    @matrix.each_with_index { |line, i|
      f.write(line.to_s + "\n")
    }
  end

  def print_to_file_small_matrix
    f = File.new("small_#{@url.split("://")[1].split("/")[0]}", 'w')
    f.write(@hrefs.to_s)
    f.write("\n")
    @small_matrix.each { |node|
      f.write(node.to_s + "\n")
    }
  end
end
