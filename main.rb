require_relative 'hangman'

# Hangman.new("#{__dir__}/10000-english-words.txt").play <-- Another option to do the same
dictionary_path = File.join(__dir__, '10000-english-words.txt')
Hangman.new(dictionary_path).play
