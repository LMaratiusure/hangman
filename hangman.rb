class Hangman
  ATTEMPTS = 7
  WORD_MIN_LENGTH = 5
  WORD_MAX_LENGTH = 12

  def initialize(dictionary)
    @secret_word = pick_random_word(dictionary)
    @attempts = ATTEMPTS
    @revealed = Array.new(@secret_word.length, '_')
    @guessed_letters = Set.new
  end

  def play
    until @attempts.zero? || solved?
      print_current_state
      guess = prompt_player
      unless @guessed_letters.add?(guess)
        puts "You already guessed '#{guess}'"
        next
      end
      if @secret_word.include?(guess)
        update_revealed(guess)
      else
        @attempts -= 1
      end
    end
    puts "The secret word was: '#{@secret_word}'. You #{solved? ? 'won!' : 'lost!'}"
  end

  private

  def pick_random_word(file)
    File.readlines(file, chomp: true)
        .select { |w| w.length.between?(WORD_MIN_LENGTH, WORD_MAX_LENGTH) }
        .sample or raise "No suitable words in #{file}"
  end

  def prompt_player
    allowed = /\A[a-z]\z/
    loop do
      print 'Make your guess: '
      input = read_line

      return input if input.match?(allowed)

      puts 'Enter letters from a to z:'
    end
  end

  def read_line
    line = gets
    return line.strip.downcase if line

    puts "\nGoodbye"
    exit
  end

  def update_revealed(char)
    @secret_word.each_char.with_index do |c, index|
      @revealed[index] = c if c == char
    end
  end

  def print_current_state
    wrong = (@guessed_letters - @secret_word.chars).to_a.join(', ')
    puts "Attempts left: #{@attempts}",
         "Wrong guesses: #{wrong}",
         @revealed.join(' '),
         ''
  end

  def solved?
    @secret_word == @revealed.join
  end
end
