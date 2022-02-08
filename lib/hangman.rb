require 'json'

# Hangman game class
class Hangman
  word_list = File.read('google-10000-english-no-swears.txt')
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
      word = IO.readlines('google-10000-english-no-swears.txt')[rand(1..10000)].chomp
      return word if word.length >= 5 && word.length <= 12
    end
  end

  # Verifies the entered character is a valid letter
  def valid_character?(char)
    return false if char.length != 1
    return false unless char.match?(/[[:alpha:]]/)
    return false if letters_guessed.include? 'char'

    true
  end

  # Checks if guessed letter appears in word, then fills in accordingly. Returns false if letter does not appear
  def make_guess(letter)
    correct_guess = false
    letters_guessed.append(letter)
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

  # Saves game in JSON format
  def save_game
    JSON.dump ({
      chosen_word: @chosen_word,
      letters_guessed: @letters_guessed,
      wrong_guesses: @wrong_guesses,
      correct_characters: @correct_characters
    })
  end

  # Loads game from JSON-formatted save
  def load_game(string)
    data = JSON.parse string
    @chosen_word = data['chosen_word']
    @letters_guessed = data['letters_guessed']
    @wrong_guesses = data['wrong_guesses']
    @correct_characters = data['correct_characters']
  end

end

hangman = Hangman.new

while true
  puts 'Enter N to start a new game, or L to load a game'
  input = gets.chomp.downcase
  if input == 'n'
    break
  elsif input == 'l'
    puts 'load!!!'
    hangman.load_game(File.read('hang_game.json'))
    break
  end
end

puts "Word is #{hangman.chosen_word}"

while true
  puts "Word so far: #{hangman.correct_characters}"
  puts "Letters guessed so far: #{hangman.letters_guessed}"
  puts "Amount of incorrect guesses: #{hangman.wrong_guesses}"
  puts 'Guess a letter, or enter @ to save your game.'
  letter = gets.chomp.downcase
  if letter == '@'
    # save game
    File.open('hang_game.json', 'w') { |f| f.write(hangman.save_game) }
  elsif hangman.valid_character?(letter)
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