require_relative 'chess/chess.rb'


loop do
  game = Chess::ChessGame.new()
  puts "Welcome to Chess\n\n"
  puts "Main menu"
  puts "   P  -- Play New game"
  puts "   L  -- Load Game"
  puts "   E  -- Exit"
  choice = gets.chomp
  case choice
  when "P" , "p"
    game.play
  when "E" , "e"
    puts "Goodbye"
    exit(0)
  when "L" , "l"
    puts "loading..."
  end
end
