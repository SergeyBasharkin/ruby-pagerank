class MatrixNode
  def initialize(i=nil,j=nil,val=nil, href = nil, ref = nil)
    @i, @j, @val, @href, @ref = i, j, val, href, ref
  end

  def i
    @i
  end

  def j
    @j
  end

  def val
    @val
  end

  def href
    @href
  end

  def ref
    @ref
  end

  def i=(i)
    @i = i
  end

  def j=(j)
    @j = j
  end

  def val=(val)
    @val = val
  end

  def ref=(val)
    @ref = val
  end

  def href=(href)
    @href = href
  end

  def to_s
      "i: #{@i}; j: #{@j}; val: #{@val}; href: #{@href}; ref: #{@ref}"  # string formatting of the object.
   end
end
