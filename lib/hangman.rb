class Hangman 
  word_list = File.read('../google-10000-english-no-swears.txt')
  attr_accessor :chosen_word, :letters_guessed, :wrong_guesses, :correct_characters

  def initialize
    @chosen_word = pick_random_word
    @letters_guessed = []
    @wrong_guesses = 0
    @correct_characters = Array.new(@chosen_word.length, '_')
  end

  # Picks a random word from the provided list that matches the length criteria
  def pick_random_word
    word = ''
    while true
      word = IO.readlines('../google-10000-english-no-swears.txt')[rand(1..10000)].chomp
      return word if word.length >= 5 && word.length <= 12
    end
  end

  # Verifies the entered character is a valid letter
  def valid_character?(char)
    return false if char.length != 1
    return false unless char.match?(/[[:alpha:]]/)

    true
  end

  # Checks if guessed letter appears in word, then fills in accordingly. Returns false if letter does not appear
  def make_guess(letter)
    correct_guess = false
    word_array = @chosen_word.split(//)
    word_array.each_with_index do |char, index|
      puts "char: #{char}, index: #{index} letter: #{letter}"
      if char == letter
        correct_guess = true
        @correct_characters[index] = letter
      end
    end
    correct_guess
  end

  # Exactly what it says
  def save_game

  end
end

while true
  puts 'Enter N to start a new game, or L to load a game'
  break if gets.chomp.downcase == 'n'
end

hangman = Hangman.new

# @chosen_word = pick_random_word
puts "Word is #{hangman.chosen_word}"
# @correct_characters = Array.new(@chosen_word.length, '_')

while true
  puts "Word so far: #{hangman.correct_characters}"
  puts "Letters guessed so far: #{hangman.letters_guessed}"
  puts "Amount of incorrect guesses: #{hangman.wrong_guesses}"
  puts 'Guess a letter, or enter @ to save your game.'
  letter = gets.chomp.downcase
  if hangman.valid_character?(letter)
    hangman.wrong_guesses += 1 unless hangman.make_guess(letter)
  else
    puts 'Invalid character!'
  end
end

# Player is first asked whether they'd like to load a game or start a new one
# Hangman boardstate is drawn to screen (the hangman himself, the guessed letters, the incorrect letters, etc)
# Player is queried for input (either a letter guess or to save the game)
# Guessed letter is checked for validity
# If valid, checks if letter is contained in word
# If so, fills in appropriate spaces
# Need to keep track of all variables so we can easily save and load them:
#   - The chosen word
#   - Guessed letters so far
#   - The amount of wrong guesses
#   - The current letters filled in on the word