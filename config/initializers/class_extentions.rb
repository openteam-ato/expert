# encoding: utf-8

class String

  def as_html
    require 'gilenson'
    self.gsub('&quot;', '"').gsub('&nbsp;', ' ').gsub('&#160;', ' ').gilensize.html_safe
  end

end

class NilClass

  def as_html
    nil
  end

end
