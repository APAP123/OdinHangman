word_list = File.read('google-10000-english-no-swears.txt')
chosen_word = ''
letters_guessed = Array.new()
wrong_guesses = 0
correct_characters = Array.new()

# Picks a random word from the provided list that matches the length criteria
def pick_random_word
  word = ''
  while true
    word = IO.readlines('google-10000-english-no-swears.txt')[rand(1..10000)].chomp
    return word if word.length >= 5 && word.length <= 12
  end
end

def valid_character?(char)
  # TODO
  true
end

while true
  puts 'Enter N to start a new game, or L to load a game'
  break if gets.chomp.downcase == 'n'
end

chosen_word = pick_random_word

while true

  puts 'Enter a letter!'

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