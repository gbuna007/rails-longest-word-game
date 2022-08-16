require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    session[:score] = 0 if session[:score].nil?
    @session = session[:score]

    10.times do
      char = Array('A'..'Z').sample.first
      @letters << char
    end
  end

  def score
    # {"word"=>"bag", "authenticity_token"=>"[FILTERED]", "letters"=>"P A C F B P Q G F S"}
    @word = params[:word].upcase
    @saved_letters = params[:letters].split(' ')

    @current_game_score = 0

    if can_build(@word, @saved_letters) && valid_en_word(@word)
      @result = "Congratulations! #{@word} is a valid English word!"
      @current_game_score += @word.length
      session[:score] += @word.length
      @session = session[:score]
    elsif can_build(@word, @saved_letters) == true && valid_en_word(@word) == false
      @result = "Sorry but #{@word} does not seem to be and English word"
    else
      @result = "Sorry but #{@word} can't be built out of #{@saved_letters.reduce { |str, s| str + ', ' + s }}"
    end
  end

  private

  # word as string, letters as array of letters
  def can_build(word, letters)
    word.split('').all? { |char| letters.include?(char) }
  end

  def valid_en_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    json = URI.open(url).read
    result = JSON.parse(json)
    result['found']
  end
end
