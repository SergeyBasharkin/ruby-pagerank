require 'nokogiri'
require 'open-uri'

class PageRankBuilder
  @hrefs = Array.new

  def getHrefs
    @hrefs
  end

  def initialize(url, count, flag="0")
    @url = url
    puts 'fetching..'
    html = open(url)
    puts 'done'

    puts 'parsing..'
    doc = Nokogiri::HTML(html)
    @hrefs = doc.css('a').to_a.uniq.delete_if{ |a|
        a["href"].nil? ||
       !a["href"].match("(https|http)://.*") ||
        a["href"] === @url ||
        (flag==="1" && !a["href"].match("(https|http)://"+@url.split("://")[1]+".*"))
    }[0, count.to_i].map{ |link|
       link["href"]
    }
  end

  def getLine(url)
    puts 'fetching..'
    html = open(url)
    puts 'done'

    puts 'parsing..'
    doc = Nokogiri::HTML(html)
    hrefs = doc.css('a').to_a.uniq.delete_if{ |a|
      a["href"].nil? || !a["href"].match("(https|http)://.*")
    }.map{ |link|
       link["href"]
    }
    line = Array.new
    @hrefs.each{ |link|
      line.push hrefs.count link
    }
    line
  end

  def build_matrix
    matrix = Array.new(Array.new)

    @hrefs.each_with_index { |href, i| matrix[i] = getLine(href) }
    matrix
  end

  def print
    matrix = build_matrix
    f = File.new('out.txt', 'w')
    matrix.each_with_index { |line, i|
      f.write(line.to_s + " " +  @hrefs[i]+"\n")
    }
  end
end
