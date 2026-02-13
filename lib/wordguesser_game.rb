class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word
  attr_reader :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end


  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      return http.post(uri, "").body
    end
  end

  def guess(letter)

    if letter.nil? || letter.length != 1 || !(letter =~ /[a-zA-Z]/) #All the possible error inputs
      raise ArgumentError
    end
    
    letter = letter.downcase

    # already guessed (either correct or wrong)
    if @guesses.include?(letter) || @wrong_guesses.include?(letter) 
      return false
    end

    if @word.include?(letter)
      @guesses += letter
      return true
    else
      @wrong_guesses += letter
      return false
    end
  end

  def word_with_guesses
    result = ""

    @word.each_char do |c|
      if @guesses.include?(c)
        result += c
      else
        result += "-"
      end
    end

    return result
  end

  def check_win_or_lose
    if word_with_guesses == @word
      return :win
    end

    if @wrong_guesses.length >= 7
      return :lose
    end

    return :play
  end

end