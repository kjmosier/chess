module ChessPieceMoves

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

     #this will be a switch and will return move_to if it is valid
     def validate_move_to(move_from, move_to, board)
       move_valid = false
       #selects chess piece
       case board[move_from[0]][move_from[1]].ord
       when 9817
         move_valid = white_pawn_move(move_from, move_to, board)
       when 9823
         move_valid = black_pawn_move(move_from, move_to, board)
       when 9814
         puts "moving a white rook"
       when 9816
         puts "moving a white knight"
       when 9815
         puts "moving a white bishop"
       when 9813
         puts "moving a white queen"
       when 9812
         puts "moving a white king"
       else
         puts "pieces move not added yet"
       end
       move_valid
     end


    def white_pawn_move(move_from, move_to, board)
      puts "moving a white pawn"
      puts "move_from: #{move_from}"
      puts "move_to: #{move_to}"
      #Cases where move is not valid
      #check to see if legal, diagonal take occurs
      puts "diagonal"
      if move_to[0] == (move_from[0] + 1) && (move_from[1] == (move_to[1]+1) || move_from[1] == (move_to[1]-1))
        return is_take?(move_from, move_to, board)
      end
      #not the same column
      puts "not same column"
      return false if move_to[1] != move_from[1]
      #more than 1 space forward  except from row 2
      puts "more than 1 except from 1"
      return false if (move_to[0] != (move_from[0] + 1)) && move_from[0] != 1
      #move from row 2 is greater than 2
      puts "greater than 2"
      return false if move_to[0] > move_from[0] + 2
      #a piece in its straight piece_in_path_straight
      puts "piece in path"
      return false if piece_in_path_straight?(move_from, move_to, board)
      true
    end

    def black_pawn_move(move_from, move_to, board)
      puts "moving a black pawn"
      puts "move_from: #{move_from}"
      puts "move_to: #{move_to}"
      #Cases where move is not valid
      #check to see if legal, diagonal take occurs
      if move_to[0] == (move_from[0] - 1) && (move_from[1] == (move_to[1]+1) || move_from[1] == (move_to[1]-1))
        return is_take?(move_from, move_to, board)
      end
      #not the same column
      return false if move_to[1] != move_from[1]
      #more than 1 space forward  except from row 2
      return false if (move_to[0] != (move_from[0] - 1)) && move_from[0] != 7
      #move from row 2 is greater than 2
      return false if move_to[0] < move_from[0] - 2
      #a piece in its straight piece_in_path_straight
      return false if piece_in_path_straight?(move_from, move_to, board)
      true
    end


    def is_take?(move_from, move_to, board)
      puts "checking is take?"
      white_pieces = (9812..9817).to_a
      black_pieces = (9818..9823).to_a
      if white_pieces.include?(board[move_from[0]][move_from[1]].ord)
        return black_pieces.include?(board[move_to[0]][move_to[1]].ord)
      end
      if black_pieces.include?(board[move_from[0]][move_from[1]].ord)
        return white_pieces.include?(board[move_to[0]][move_to[1]].ord)
      end
      false
    end



    def terminus_open?
      return true
    end

    def piece_in_path_straight?(move_from, move_to, board)
      col = move_from[1]
      #spot after or before piece
      start = move_from[0] < move_to[0] ? move_from[0]+1 : move_to[0]+1
      stop = move_from[0] < move_to[0] ? move_to[0]-1 : move_from[0]-1
      start.upto(stop) do |l|
        puts "cell in path:"
        p board[l][col]
        return true if board[l][col] != "."
      end
      false
    end


=begin

strategy
rook legal moves(move_from,move_to, board)
   asses possible moves
   see if move_to is part of set_board
   return true or false

=end






end
