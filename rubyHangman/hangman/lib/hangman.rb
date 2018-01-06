require "yaml"

class Game
  def initialize(game_word)
   
    @game_word = game_word
    puts @game_word
    @guesses_left = 6
    @correct_guess = Array.new(@game_word.length, "_")
    @wrong_guesses = Array.new
    gameplay(game_word)

  end
  
  def display
    
    case @guesses_left
    when 6
      puts "6 wrong guesses to go!"
      puts "------"
      puts "|    |"
      puts "|   "
      puts "| "
      puts "| "
      puts "|"
    when 5
      puts "Only 5 wrong guesses left!"
      puts "------"
      puts "|    |"
      puts "|    O"
      puts "| "
      puts "| "
      puts "|"
    when 4
      puts "4 more wrong guesses!"
      puts "------"
      puts "|    |"
      puts "|    O"
      puts "|    |"
      puts "|   "
      puts "|"
    when 3
      puts "Only 3 more?!"
      puts "------"
      puts "|    |"
      puts "|    O"
      puts "|  --|"
      puts "|   "
      puts "|"
    when 2
      puts "2! He's getting nervous..."
      puts "------"
      puts "|    |"
      puts "|    O"
      puts "|  --|--"
      puts "|   "
      puts "|"
    when 1
      puts "Last guess!"
      puts "------"
      puts "|    |"
      puts "|    O"
      puts "|  --|--"
      puts "|   / "
      puts "|"
    when 0
      puts "You lose!"
      puts "------"
      puts "|    |"
      puts "|    O"
      puts "|  --|--"
      puts "|   / \\"
      puts "|"
    else
      puts "Something broke..."
    end
    puts @correct_guess.join(" ")
    puts 
    puts "incorrect guesses:"
    puts @wrong_guesses.join(" ")
  end
  
  def gameplay(game_word)
    won = false
    while !won && @guesses_left > 0
      display
      puts "Guess a letter! Or enter '1' to save"
      input = gets.chomp.downcase
      
      if input.length == 1 && input != '1'
        if @game_word.include? input
          puts "Good guess!"
          while @game_word.include? input
            @correct_guess[@game_word.index(input)] = input
            @game_word[input] = "_"
          end
        else
          puts "Nope!"
          @guesses_left -= 1
          @wrong_guesses.push(input)
        end
      elsif input.length == 1 && input == '1'
        save
      else
        puts "Invalid guess.  Only 1 letter at a time!"
      end
      
      if !@correct_guess.include? "_"
        won = true
        display
        puts "You win!"
        puts "The word was #{@correct_guess.join}"
      else
        won = false
        display
        puts "The word was #{game_word}"
      end
      
    end
  end
  
  def save
    Dir.mkdir("save") unless Dir.exists? "save"
    filename = "save/game.txt"
    serialized_object = YAML::dump(self)
    #puts serialized_object
    File.open(filename, 'w') do |file|
      file.puts serialized_object
    end
    puts "saved!"
    abort
  end
  
end

words = File.readlines "5desk.txt"
game_word = ""
loop do
  game_word = words[Random.rand(words.length)].chomp
  break if (game_word.length >= 5 && game_word.length <= 12)
end

puts "Hangman!"
puts "Enter '1' to load previous game, or any other key to begin"
input = gets.chomp
if input == '1'
  puts "loading..."
  filename = "save/game.txt"
  game = YAML::load(File.open(filename, "r"))
  game.gameplay
else
  Game.new(game_word)
end

