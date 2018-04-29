# Scrapes web page containing word and the individual pages with their
# definitions.
class Wordwise::Scraper
  attr_reader :list_urls

  BASEPATH = 'https://en.oxforddictionaries.com'

  # Scrapes page with list of word lists.
  def self.scrape_word_lists
    html = Nokogiri::HTML(open(BASEPATH + '/explore/word-lists'))
    @list_urls, lists = [], []

    (0..html.css('.record').length - 1).each do |i|
      @list_urls << BASEPATH + html.css('.record a')[i].attribute('href').value
      @list_urls.delete_if { |u| u =~ /phobias/ } # Removes list not fitting format
      lists << html.css('.record h2')[i].text
      lists.delete_if { |l| l =~ /phobias/ } # Removes list not fitting format
    end
    lists
  end

  # Scrapes a page with a word list.
  def self.scrape_word_list(page_idx)
    doc = Nokogiri::HTML(open(@list_urls[page_idx]))
    @words_defs = {}

    (0..doc.css('tr').length - 1).each do |i|
      @words_defs.store(doc.css('tr')[i].css('td')[0].text, doc.css('tr')[i].css('td')[1].text)
    end
    # Removes invalid entries
    @words_defs.delete('')
    @words_defs.delete_if { |w| w =~ /\W/ || w =~ /xylene/ }
    @words_defs_ary = @words_defs.to_a
  end

  # Samples 4 urls to words' pages and parse the question word, its origin and
  # definition, and 3 more definitions.
  def self.scrape_entry_pages
    docs, word_urls, question_words, question_defs = [], [], [], []

    begin
      # Samples from index 1 of array to avoid any column headings.
      question_words_defs = @words_defs_ary[1..@words_defs_ary.size - 1].sample(4)

      question_words_defs.each_index do |i|
        question_words << question_words_defs[i][0]
        question_defs << question_words_defs[i][1]
      end

      question_words.each_index do |i|
        word_urls << "#{BASEPATH}/definition/#{question_words[i]}"
        docs << Nokogiri::HTML(open(word_urls[i]))
      end

      origin = docs[0].css('.senseInnerWrapper p')[-1].text
      [question_words, question_defs, origin]
    rescue NoMethodError => e # Selects new word list when data missing.
      scrape_entry_pages
    end
  end
end
