# coding: utf-8

require "kconv"
require "jkf"
require "sinatra"
if development?
  require "sinatra/reloader"
  require "pry"
end

get "/" do
  erb :index
end

post "/convert" do
  str = params["kifu-file"][:tempfile].read.toutf8
  begin
    jkf = Jkf.parse(str)
    converter = case params["convert-type"]
                when "ki2"
                  Jkf::Converter::Ki2.new
                when "kif"
                  Jkf::Converter::Kif.new
                when "csa"
                  Jkf::Converter::Csa.new
                end
    @result = converter.convert(jkf)
  rescue Jkf::FileTypeError, Jkf::Parser::ParseError
    @result = "読み込み失敗"
  rescue Jkf::Converter::ConvertError
    @result = "変換失敗"
  end
  erb :index
end
