require 'open-uri'
require 'rexml/document'

module RosettaCode

  URL_ROOT = "http://rosettacode.org/mw"

  def self.get_url(page, query)
    begin
      # Ruby 1.9.2
      pstr = URI.encode_www_form_component(page)
      qstr = URI.encode_www_form(query)
    rescue NoMethodError
      require 'cgi'
      pstr = CGI.escape(page)
      qstr = query.map {|k,v|
        "%s=%s" % [CGI.escape(k.to_s), CGI.escape(v.to_s)]}.join("&")
    end
    url = "#{URL_ROOT}/#{pstr}?#{qstr}"
    p url if $DEBUG
    url
  end

  def self.get_api_url(query)
    get_url "api.php", query
  end

  def self.category_members(category)
    query = {
      "action" => "query",
      "list" => "categorymembers",
      "cmtitle" => "Category:#{category}",
      "format" => "xml",
      "cmlimit" => 500,
    }
    while true
      url = get_api_url query
      doc = REXML::Document.new open(url)

      REXML::XPath.each(doc, "//cm") do |task|
        yield task.attribute("title").value
      end

      continue = REXML::XPath.first(doc, "//query-continue")
      break if continue.nil?
      cm = REXML::XPath.first(continue, "categorymembers")
      query["cmcontinue"] = cm.attribute("cmcontinue").value
    end
  end

end
