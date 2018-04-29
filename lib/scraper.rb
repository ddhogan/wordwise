# Scrape web page containing word and the individual pages with their
# definitions.
class Wordwise::Scraper
  attr_accessor :words, :origin, :doc, :entry_urls, :question_array, :list_urls, :lists, :words_ary

  BASEPATH = 'https://en.oxforddictionaries.com'

  # Scrape page with list of word lists.
  def self.scrape_word_lists
    html = Nokogiri::HTML(open(BASEPATH + '/explore/word-lists'))
    @list_urls = []
    @lists = []
    (0..html.css('.record').length - 1).each do |i|
      @list_urls << BASEPATH + html.css('.record a')[i].attribute('href').value
      @lists << html.css('.record h2')[i].text
    end
  end

  def self.lists
    @lists = @lists
  end

  # Scrape a page with a word list.
  def self.scrape_word_list(page_idx)
    @doc = Nokogiri::HTML(open(@list_urls[page_idx]))
    @words_ary = []
    (0..@doc.css('tr').length - 1).each do |i|
      @words_ary << @doc.css('tr')[i].css('td')[0].text
    end
    @words_ary.pop # Remove empty td
  end

  # Sample 4 urls to words' pages and parse the question word, its origin and
  # definition, and 3 more definitions.
  def self.scrape_entry_pages
    docs = []
    @words = []
    @defs = []
    word_urls = []
    begin
      question_words = @words_ary[1..@words_ary.size - 1].sample(4)
      question_words.each_index do |i|
        word_urls << "#{BASEPATH}/definition/#{question_words[i]}"
        # docs << Nokogiri::HTML(open(question_urls[i]))
      end
binding.pry
      docs.each_index do |i|
        @words << docs[i].css('.hw').text.match(/^[a-zA-Z]+/).to_s
        @defs << docs[i].css('.ind').first.text
      end
      @origin = docs[0].css('.senseInnerWrapper p').text
      @question_array = [@words, @defs, @origin]
    rescue NoMethodError => e
      scrape_entry_pages
    end
  end
end