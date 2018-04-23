require 'byebug'

class Node
  attr_reader :children, :left_text, :right_text, :insert_text, :token

  MAPPING = {
    "opening-tag" => "{",
    "closing-tag" => "}",
    "body" => "<html>\n  <header>\n    <meta charset=\"utf-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n    <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\">\n<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css\" integrity=\"sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp\" crossorigin=\"anonymous\">\n<style>\n.header{margin:20px 0}nav ul.nav-pills li{background-color:#333;border-radius:4px;margin-right:10px}.col-lg-3{width:24%;margin-right:1.333333%}.col-lg-6{width:49%;margin-right:2%}.col-lg-12,.col-lg-3,.col-lg-6{margin-bottom:20px;border-radius:6px;background-color:#f5f5f5;padding:20px}.row .col-lg-3:last-child,.row .col-lg-6:last-child{margin-right:0}footer{padding:20px 0;text-align:center;border-top:1px solid #bbb}\n</style>\n    <title>Scaffold</title>\n  </header>\n  <body>\n    <main class=\"container\">\n      {}\n      <footer class=\"footer\">\n        <p>&copy; RONTOMATON 2018</p>\n      </footer>\n    </main>\n    <script src=\"js/jquery.min.js\"></script>\n    <script src=\"js/bootstrap.min.js\"></script>\n  </body>\n</html>\n",
    "header" => "<div class=\"header clearfix\">\n  <nav>\n    <ul class=\"nav nav-pills pull-left\">\n      {}\n    </ul>\n  </nav>\n</div>\n",
    "btn-active" => "<li class=\"active\"><a href=\"#\">[]</a></li>\n",
    "btn-inactive" => "<li><a href=\"#\">[]</a></li>\n",
    "row" => "<div class=\"row\">{}</div>\n",
    "single" => "<div class=\"col-lg-12\">\n{}\n</div>\n",
    "double" => "<div class=\"col-lg-6\">\n{}\n</div>\n",
    "quadruple" => "<div class=\"col-lg-3\">\n{}\n</div>\n",
    "btn-green" => "<a class=\"btn btn-success\" href=\"#\" role=\"button\">[]</a>\n",
    "btn-orange" => "<a class=\"btn btn-warning\" href=\"#\" role=\"button\">[]</a>\n",
    "btn-red" => "<a class=\"btn btn-danger\" href=\"#\" role=\"button\">[]</a>",
    "big-title" => "<h2>[]</h2>",
    "small-title" => "<h4>[]</h4>",
    "text" => "<p>[]</p>\n"
  }

  CONTAIN_CHILDREN = ["body", "header", "row", "single", "double", "quadruple"]
  NO_CHILDREN = ["btn-active", "btn-inactive", "btn-green", "btn-orange", "btn-red", "big-title", "small-title", "text"]

  def self.compile(dsl_source)
    tokens = dsl_source.split(/,\s*|\s/)
    root = Node.new("body")
    self.build_tree(root, tokens)
    root.generate
  end

  def self.build_tree(root, tokens)
    # never pass in first as curly brace

    until tokens.empty?
      token = tokens.shift
      if token == "{"
        self.build_tree(root.children.last, tokens)
      elsif token == "}"
        return
      else
        new_node = Node.new(token)
        root.add_child(new_node)
      end
    end

    root
  end

  def initialize(token)
    @children = []
    @token = token
    @insert_text = NO_CHILDREN.include?(@token) #true or false
    @left_text, @right_text = split_text
  end

  def split_text
    if @insert_text
      parts = MAPPING[@token].split("[]")
    else
      parts = MAPPING[@token].split("{}")
    end
  end

  def generate
    html = @left_text
    @children.each do |child|
      html += child.generate
    end
    html += "RANDOMLY GENERATED TEXT" if @insert_text
    html += @right_text
  end

  def add_child(node)
    @children.push(node)
  end

end


#
# header = Node.new('header')
# btn = Node.new('btn-inactive')
# header.add_child(btn)
# p header.generate

# =>
# "<li><a href=\"#\">[]</a></li>\n"


# "header { btn-inactive, btn-inactive, btn-inactive, btn-active, btn-inactive }"

# source = "btn-inactive, btn-inactive, btn-inactive, btn-active, btn-inactive"
source = "header { btn-inactive, btn-inactive, btn-inactive, btn-active, btn-inactive }"
# source =
# "header {
# btn-inactive, btn-active, btn-inactive, btn-inactive, btn-inactive
# }
# row {
# quadruple {
# small-title, text, btn-orange
# }
# quadruple {
# small-title, text, btn-red
# }
# quadruple {
# small-title, text, btn-green
# }
# quadruple {
# small-title, text, btn-orange
# }
# }
# row {
# single {
# small-title, text, btn-green
# }
# }"

puts Node.compile(source)
# node = Node.compile(source)
# debugger
#
# puts "done"
