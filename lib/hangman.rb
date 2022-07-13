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

  # Checks to see if game is over
  def game_over?
    unless correct_characters.include? '_'
      puts 'You win!'
      return true
    end

    if wrong_guesses >= 6
      puts 'Out of guesses, game over!'
      return true
    end

    false
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

# Queries user for file name and checks if it exists.
def verify_file
  puts 'Please enter the name of your saved game, including file extension'
  while true
    file = gets.chomp
    if File.exist?(file)
      puts 'Loading game...'
      return file
    else
      puts 'File not found! Please try again.'
    end
  end
end

# Draws the hangman to screen
def draw_hangman(wrong_guesses)
  wrong_guesses >= 1 ? head = 'O' : head = ' ' 
  wrong_guesses >= 2 ? body = '|' : body = ' '
  wrong_guesses >= 3 ? left_arm = '-' : left_arm = ' '
  wrong_guesses >= 4 ? right_arm = '-' : right_arm = ' '
  wrong_guesses >= 5 ? left_leg = '/' : left_leg = ' '
  wrong_guesses >= 6 ? right_leg = '\\' : right_leg = ' '

  puts '                   |¯¯¯¯¯¯|'
  puts '                   ' + head + '      |'
  puts '                  ' + left_arm + body + right_arm + '     |'
  puts '                  ' + left_leg + ' ' + right_leg + '     |'
  puts '                          |'
  puts '                          |'
  puts '             |¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|'
end

hangman = Hangman.new

while true
  puts 'Enter N to start a new game, or L to load a game'
  input = gets.chomp.downcase
  if input == 'n'
    puts 'Starting new game...'
    break
  elsif input == 'l'
    hangman.load_game(File.read(verify_file))
    break
  end
end

while true
  # Command to draw goes here

  draw_hangman(hangman.wrong_guesses)
  break if hangman.game_over?

  puts "Word so far: #{hangman.correct_characters}"
  puts "Letters guessed so far: #{hangman.letters_guessed}"
  puts "Amount of incorrect guesses: #{hangman.wrong_guesses}"
  puts 'Guess a letter, or enter @ to save your game.'

  letter = gets.chomp.downcase

  if letter == '@'
    # save game
    puts 'Save game as?'
    file = gets.chomp
    File.open("#{file}.json", 'w') { |f| f.write(hangman.save_game) }
    puts "Game saved as #{file}.json"
  elsif hangman.valid_character?(letter)
    hangman.wrong_guesses += 1 unless hangman.make_guess(letter)
  else
    puts 'Invalid character!'
  end
end

puts 'Thanks for playing!'
