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



# SEE NOTES AT BOTTOM FOR WHERE TO PICK UP!!!!!!!!!!!
# SEE NOTES AT BOTTOM FOR WHERE TO PICK UP!!!!!!!!!!!
# SEE NOTES AT BOTTOM FOR WHERE TO PICK UP!!!!!!!!!!!
# SEE NOTES AT BOTTOM FOR WHERE TO PICK UP!!!!!!!!!!!


  class ChessGame
    include ChessPieceMoves

      attr_accessor :board

      def initialize
        #@board is set [row][col]
        @board = set_board
        #track whose turn: white or !white (black)
        @white = true
        @captured_white = []
        @captured_black = []
        #is game still active?
        @game = true
        @black_can_castle_left = true
        @white_can_castle_right = true
     end



     def play
       set_board
       until !@game
         display_board
         puts "#{whose_turn} turn."
         #disabled for testing
         #prompt
         move
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
         valid = validate_move_to(move_from, move_to)
         puts "Invalid move for #{@board[move_from[0]][move_from[1]]}" if !valid
       end
       register_move(move_from, move_to)
       @white = !@white
     end

     def register_move(move_from, move_to)
       puts "completing move"
       if is_white?(move_to) || is_black?(move_to)
         is_black?(move_to) ? @captured_white << piece_at(move_to) : @captured_black << piece_at(move_to)
       end
       @board[move_to[0]][move_to[1]] = piece_at(move_from)
       @board[move_from[0]][move_from[1]] = "."
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
        arr[2][1] = "\u2657"
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

      def whose_turn
        @white ? "White's" : "Black's"
      end


  end
end

game = Chess::ChessGame.new()
game.play



=begin
    9/16 follow up notes...
    building out bishop move need to accomodate for all four directions it can travel in piece_in_path_diagonal
    then build Queen
    then build king
    then make move into check validation


    9/15 follow up notes...   Pawn moves are completely built out.  next will be rook.u

    Things to do.   if take is the king game == over  change in register_move
    Build out piece moves... one by one  5 more total.

    tricky add-ons:
        castling
        determine if move will put you in check... invalid.
            will build this out by running through each of opponents pieces and see if they can land on king

    save board
    load board
    that's it unless I want to build ai but would rather just start in on my web project...





   1. moves
      a. prompt move  done
      b. execute move
              b1. is valid
                  b11. by piece
      c. see if piece is taken

   2. player moves    done
   3. determine take   done
   3. save board
   4. load board
   5 ai
=end
