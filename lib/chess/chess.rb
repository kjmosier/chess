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
        #for use on Web-site to dipslay captured units
        @captured_white = []
        @captured_black = []
        #is game still active?
        @game = true
        #castling
        @black_qr_can_castle = true
        @black_kr_can_castle = true
        @white_qr_can_castle = true
        @white_kr_can_castle = true
     end



     def play
       until !@game
         display_board
         puts "#{whose_turn} turn."
         move
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
       #first case is for castling, everything else gets captured and replaced
       if (is_white?(move_from) && is_white?(move_to)) || (is_black?(move_from) && is_black?(move_to))
         temp = piece_at(move_to).dup
         @board[move_to[0]][move_to[1]] = piece_at(move_from)
         @board[move_from[0]][move_from[1]] = temp
       else
         if is_white?(move_to) || is_black?(move_to)
           is_black?(move_to) ? @captured_white << piece_at(move_to) : @captured_black << piece_at(move_to)
         end
         @board[move_to[0]][move_to[1]] = piece_at(move_from)
         @board[move_from[0]][move_from[1]] = "."
       end
     end


      #Sets the board as an array of 8 rows with 8 columns
      def set_board
        arr = []
        arr << ["\u2656","\u2658","\u2657","\u2655","\u2659","\u2657","\u2658","\u2656"]
        arr << ("\u2659 "* 8).split()
        4.times do
            arr << (". " * 8).split()
        end
        arr << ("\u265f "* 8).split()
        arr << ["\u265c","\u265e","\u265d","\u265b","\u265f","\u265d","\u265e","\u265c"]
        #test cases
        arr[4][1] = "\u2654"
        arr[3][5] = "\u265a"
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





=begin
   9/18 end of day notes
   need to add save and load functionality
   need to build out resign method.



   9/18 move into check... problem with pawns only registering hit if king is in front of them not  beside them
   add if king is taken in register_move then game is over
   save board
   load board



    9/17
    COMPLETE  castleing
    COMPLETE need to add is_king_in_check validation to prevent moving king into check..

    9/16 follow up notes...
    COMPLETE building out bishop move need to accomodate for all four directions it can travel in piece_in_path_diagonal
    COMPLETE then build Queen
    COMPLETE then build king


    9/15 follow up notes...   Pawn moves are completely built out.  next will be rook.u
    COMPLETE Build out piece moves... one by one  5 more total.

    that's it unless I want to build ai but would rather just start in on my web project...



orig outline...

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
