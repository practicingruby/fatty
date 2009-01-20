$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require "fatty"

class PrawnPlugin < Fatty::Format
  require "rubygems"
  require "prawn"

  write_mode "wb"

  def doc
    @doc ||= Prawn::Document.new
  end

  def self.inherited(base)
    base.write_mode(write_mode)
  end
end

module Nameable
  def name
    params[:name]
  end
end

class MyReport < Fatty::Formatter

  required_params :name
  helpers Nameable

  format :pdf, :base => PrawnPlugin do

    def render
      doc.text "Hello #{name}"
      doc.render
    end

  end

  format :txt do

    def render
      "Hello #{name}"
    end

  end

end

MyReport.render_file("foo.pdf", :name => "Gregory Brown")
puts MyReport.render(:txt, :name => "Gregory Brown")
