require_relative 'pieces'

module Chess

=begin
  Unicode for chess pieces:

  Piece              UTF8      Ord     Piece              UTF8      Ord
  White Pawn   =   "\u2659"  = 9817    Black Pawn   =  "\u265f"  = 9823
  White Rook   =   "\u2656"  = 9814    Black Rook   =  "\u265c"  = 9820
  White Knight =   "\u2658"  = 9816    Black Knight =  "\u265e"  = 9822
  White Bishop =   "\u2657"  = 9815    Black Bishop =  "\u265d"  = 9821
  White Queen  =   "\u2655"  = 9813    Black Queeen =  "\u265b"  = 9819
  White King   =   "\u2654"  = 9812    Black King   =  "\u265a"  = 9818
=end

  class ChessGame
    include ChessPieceMoves

      attr_accessor :board

      def initialize
        #@board is set [row][col]
        @board = set_board
        #track whose turn: white or !white (black)
        @white = true
        @captured_white
        @captured_black
        #is game still active?
        @game = true
     end



     def play
       set_board
       display_board
       until !@game
         prompt
       end
     end



     def prompt
       puts "Please select option: \n m: move \n s: save \n q: quit"
       choice = gets.chomp
       case choice
       when "m"
         move
       else
         @game = false
       end
     end


     def move
       valid = false
       until valid
         puts "Move from: "
         move_from = validate_move_from
         puts "Move To:"
         move_to = get_move
         valid = validate_move_to(move_from, move_to, @board)
         puts "Invalid move for #{@board[move_from[0]][move_from[1]]}" if !valid
       end
       register_move
       #turns are disabled until black moves are built out !!!!!!!
       #@white = !@white
     end


     def register_move
       puts "completed move"
     end



     def validate_move_from
       move_from = get_move
       #validate White's turn and white piece chosen or Black's turn and black piece chosen
       #using .ord to see if piece is in range of white or black pieces see chart above.
       until (@white && (9812..9817).include?(@board[move_from[0]][move_from[1]].ord)) || (!@white && (9818..9823).include?(@board[move_from[0]][move_from[1]].ord))
          puts "Invalid selection!"
          puts "Try a different square:"
          move_from = get_move
       end
       return move_from
     end



     def get_move
       choice = "XXX"
       scanned = choice.scan(/[a-g][1-8]/).join
       until choice.size == 2 && scanned.size == 2
         puts "To enter space type column then row. e.g. \"a1\""
         choice = gets.chomp
         scanned = choice.scan(/[a-g][1-8]/).join
       end
       #convert to coords on @board array
       #  -97  to get column  'a' = 97 ascii
       # @board format is [row][col]
       col = scanned[0].ord - 97
       row = scanned[1].to_i - 1
       return [row , col]
     end



      #Sets the board as an array of 8 rows with 8 columns
      def set_board
        arr = []
        arr << ["\u2656","\u2658","\u2657","\u2654","\u2655","\u2657","\u2658","\u2656"]
        arr << ("\u2659 "* 8).split()
        4.times do
            arr << (". " * 8).split()
        end
        arr << ("\u265f "* 8).split()
        arr << ["\u265c","\u265e","\u265d","\u265b","\u265a","\u265d","\u265e","\u265c"]
        #test case
        arr[2][1] = "\u265f"
        arr
     end



      #prints board uses .'s  to represent empty squares.
      def display_board
         puts "      " + ("_" * 47)
         8.downto(1) do |l|
            puts "     " +("|     " * 8 ) + "|"
            puts "  #{l}  |  " + @board[l-1].join("  |  ") + "  |"
            puts "     " +("|_____" * 8 ) + "|"
         end
         puts (" " * 8) + ('a'..'h').to_a.join("     ")
      end


  end
end

game = Chess::ChessGame.new()
game.play



=begin

   1. moves
      a. prompt move
      b. execute move
              b1. is valid
                  b11. by piece
      c. see if piece is taken

   2. player moves
   3. determine take
   3. save board
   4. load board
   5 ai
=end
