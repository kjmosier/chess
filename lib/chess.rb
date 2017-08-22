require_relative 'pieces'

module Chess

=begin
  Unicode for chess pieces:
  White Pawn   =   "\u2659"      Black Pawn   =  "\u265f"

  White Rook   =   "\u2658"      Black Rook   =  "\u265c"
  White Knight =   "\u2656"      Black Knight =  "\u265e"
  White Bishop =   "\u2657"      Black Bishop =  "\u265d"
  White Queen  =   "\u2655"      Black Queeen =  "\u265b"
  White King   =   "\u2654"      Black King   =  "\u265a"
=end

  class ChessGame
      attr_accessor :board

      def initialize
        @board = set_board
        @pieces = create_pieces
     end

     def play
       set_board
       display_board
     end

      def set_board
        arr = []
        arr << ["\u265c","\u265e","\u265d","\u265b","\u265a","\u265d","\u265e","\u265c"]
        arr << ("\u265f "* 8).split()
        4.times do
            arr << (". " * 8).split()
        end
        arr << ("\u2659 "* 8).split()
        arr << ["\u2658","\u2656","\u2657","\u2655","\u2654","\u2657","\u2656","\u2658"]
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
