# Assemble a question consisting of a word and its definition shuffled with 3
# other definitions.
class Wordwise::Question
  attr_reader :word, :def, :defs, :origin

  @@all = []
  begin
    # Set instance variables for Question objects.
    def initialize
      question_array = Wordwise::Scraper.scrape_entry_pages
      @word = question_array[0][0]
      @def = question_array[1][0]
      @defs = question_array[1].shuffle
      @origin = question_array[2]
      @@all << self
    end

    def self.all
      @@all
    end

  rescue NoMethodError => e
    cli = Wordwise::CLI.new
    cli.exit
  end
end
