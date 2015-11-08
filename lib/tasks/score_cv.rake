require 'pdf-reader'
require 'engtagger'
require 'csv'

namespace :score_cv do

  task :score do
    reader = PDF::Reader.new(ENV['filename'])
    text = ""

    reader.pages.each do |p|
      text += p.text
    end

    score(text)
  end

  def score(text)
    colleges = CSV.read(Rails.root.join('lib', 'tasks', 'colleges.csv'))
    score = 50
    tgr = EngTagger.new

    colleges.each do |college|
       if text.force_encoding('ASCII-8BIT').downcase.include? college[0].force_encoding('ASCII-8BIT').downcase
         puts "found " + college[0]
         score += college[1].to_f / 5
       end
     end

    tagged = tgr.add_tags(text)
    proper_nouns = tgr.get_proper_nouns(tagged)
    words = tgr.get_words(tagged)

    score += (proper_nouns.length * 30 / words.length)

     puts score

  end
end
