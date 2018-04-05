# [] solve for broken link for "Argus-eyed", etc.

require 'open-uri'
require 'pry'
require 'nokogiri'

class Question

  attr_accessor :word_1, :definition_1, :definition_2, :definition_3, :definition_4, :definitions, :definitions_s, :length, :origin_1, :rand_word_no_2, :word_nos

  def initialize
    # @@word_nos.clear
    @word_nos = []
    doc = Nokogiri::HTML(open("https://en.oxforddictionaries.com/explore/weird-and-wonderful-words"))
    words = doc.css('td a')
    @length = words.length
    randomize

    entry_url_1 = doc.css('td a')[@word_nos[0]].attribute('href').value.split(':').to_a.insert(1, 's:').join
    doc_1 = Nokogiri::HTML(open(entry_url_1))
    @word_1 = doc_1.css('.hw').text.match(/^[a-zA-Z]+/)
    @definition_1 = doc_1.css('.ind').first.text
    @origin_1 = doc_1.css('.senseInnerWrapper p').text

    entry_url_2 = doc.css('td a')[@word_nos[1]].attribute('href').value.split(':').to_a.insert(1, 's:').join
    doc_2 = Nokogiri::HTML(open(entry_url_2))
    word_2 = doc_2.css('.hw').text.match(/^[a-zA-Z]+/)
    @definition_2 = doc_2.css('.ind').first.text
    origin_2 = doc_2.css('.senseInnerWrapper p').text

    entry_url_3 = doc.css('td a')[@word_nos[2]].attribute('href').value.split(':').to_a.insert(1, 's:').join
    doc_3 = Nokogiri::HTML(open(entry_url_3))
    word_3 = doc_3.css('.hw').text.match(/^[a-zA-Z]+/)
    @definition_3 = doc_3.css('.ind').first.text
    origin_3 = doc_3.css('.senseInnerWrapper p').text

    entry_url_4 = doc.css('td a')[@word_nos[3]].attribute('href').value.split(':').to_a.insert(1, 's:').join
    doc_4 = Nokogiri::HTML(open(entry_url_4))
    word_4 = doc_4.css('.hw').text.match(/^[a-zA-Z]+/)
    @definition_4 = doc_4.css('.ind').first.text
    origin_4 = doc_4.css('.senseInnerWrapper p').text

    @definition = @definition_1
    @definitions = [@definition_1, @definition_2, @definition_3, @definition_4]
    @definitions_s = @definitions.shuffle
  end

  def randomize
    until @word_nos.length == 4
      rand_no = rand(0..@length - 1)
      @word_nos.include?(rand_no) ? randomize : @word_nos << rand_no
    end
    @word_nos
  end
end

# tq = Question.new
