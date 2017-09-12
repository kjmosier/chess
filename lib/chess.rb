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
      attr_accessor :board

      def initialize
        @board = set_board
        @pieces = create_pieces
        @white = true
     end

     def play
       set_board
       display_board
       prompt
       p @board
     end



     def prompt
       puts "Please select option: \n m: move \n s: save \n q: quit"
       choice = gets.chomp
       case choice
       when"m"
         move
       else
         return true
       end
     end

     def move
       puts "To enter space type column then row. e.g. \"a1\""
       puts "Move from: "
       move_from = get_move
       validate_move_from(move_from)
     end

     def validate_move_from(move_from)
             #  -97  to get column  'a' = 97 ascii
       y = move_from[0].ord - 97
       x = move_from[1].to_i - 1
       p @board[x][y]
       piece = @board[x][y]
       p piece.ord
      #  if @white && @board[x][y][-1] =~ /[[:digit:]]/
      #    puts "white!"
      #  else
      #    puts "not white"
      #  end
     end

     def get_move
       choice= gets.chomp
       if choice.size != 2
         puts "To enter space type column then row. e.g. \"a1\""
         get_move
         return
       end
       scanned = choice.scan(/[a-g][1-8]/).join
       if scanned.size != 2
         puts "To enter space type column[a-g] then row[1-8]. e.g. \"a1\""
         get_move
         return
       end
       scanned
     end

      def set_board
        arr = []
        arr << ["\u2656","\u2658","\u2657","\u2654","\u2655","\u2657","\u2658","\u2656"]
        arr << ("\u2659 "* 8).split()
        4.times do
            arr << (". " * 8).split()
        end
        arr << ("\u265f "* 8).split()
        arr << ["\u265c","\u265e","\u265d","\u265b","\u265a","\u265d","\u265e","\u265c"]
        arr
     end




      def display_board
         puts "      " + ("_" * 47)
         8.downto(1) do |l|
            puts "     " +("|     " * 8 ) + "|"
            puts "  #{l}  |  " + @board[l-1].join("  |  ") + "  |"
            puts "     " +("|_____" * 8 ) + "|"
         end
         puts (" " * 8) + ('a'..'g').to_a.join("      ")
      end

     def create_pieces
     end

  end
end

#Uses multi dimensional array to keep track of squares but this is extra baggage... increases complexity more than improves functionality
 #  def set_board
 #      arr = []
 #      0.upto(7) do |i|
 #          col = 'a'
 #          row = []
 #          0.upto(7) do |_j|
 #              row << ["#{col}#{i + 1}", "#{i}"]
 #              col.next!
 #          end
 #          arr << row
 #      end
 #      arr
 #   end


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
