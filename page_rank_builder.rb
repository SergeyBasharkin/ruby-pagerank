require 'nokogiri'
require 'open-uri'

class PageRankBuilder
  @hrefs = Array.new

  def getHrefs
    @hrefs
  end

  def initialize(url = nil , count = 0, flag="1", file=true)
    unless file
      @url = url
      puts 'fetching..'
      html = open(url)
      puts 'done'

      puts 'parsing..'
      doc = Nokogiri::HTML(html)
      @hrefs = doc.css('a').to_a.uniq.delete_if{ |a|
          a["href"].nil? ||
          a["href"].match("/#")
          # (flag==="1" &&
          #   (
          #     !a["href"].match("(https|http)://"+@url.split("://")[1]+".*") ||
          #     !a["href"].match("/.*")
          #   )
          # )
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
    file = File.new("./out.txt", "r")
    line = file.gets
    line.slice!("\n")
    line.slice!("[")
    line.slice!("]")
    hfs = line.split(",")
    hfs.map! {|e|
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
    lines
  end

  def build_matrix
    matrix = Array.new(Array.new)
    @hrefs.each_with_index { |href, i| matrix[i] = getLine(href) }
    @hrefs.size.times {|i| matrix[i][i] = 0 }
    matrix
  end

  def print_to_file
    matrix = build_matrix
    f = File.new('out.txt', 'w')
    f.write(@hrefs.to_s)
    f.write("\n")
    matrix.each_with_index { |line, i|
      f.write(line.to_s + "\n")
    }
  end
end
