module ChessPieceMoves
    #     Unicode for chess pieces:
    #
    #     Piece              UTF8      Ord     Piece              UTF8      Ord
    #     White Pawn   =   "\u2659"  = 9817    Black Pawn   =  "\u265f"  = 9823
    #     White Rook   =   "\u2656"  = 9814    Black Rook   =  "\u265c"  = 9820
    #     White Knight =   "\u2658"  = 9816    Black Knight =  "\u265e"  = 9822
    #     White Bishop =   "\u2657"  = 9815    Black Bishop =  "\u265d"  = 9821
    #     White Queen  =   "\u2655"  = 9813    Black Queeen =  "\u265b"  = 9819
    #     White King   =   "\u2654"  = 9812    Black King   =  "\u265a"  = 9818



    #returns true if there is a clear, legal path from move_from to move_to for each chess piece
    #calls piece_can_move_there a large switch which finds which piece is to be moved and routes it to an individual helper method
    def validate_move_to(move_from, move_to)
        # automatically invalid if own piece at terminus --covers selecting same square --exception  Castling
        if (is_white?(move_from) && is_white?(move_to)) || (is_black?(move_from) && is_black?(move_to))
            puts 'cannot move onto own piece! unless castling'
            return can_castle?(move_from, move_to)
        end
        return false if !piece_can_move_there?(move_from, move_to)
        #cannot move into check
        temp_board = @board.dup
        @board[move_to[0]][move_to[1]] = piece_at(move_from)
        @board[move_from[0]][move_from[1]] = "."
        valid = !in_check?
        @board = temp_board
        valid
    end


    #returns true if active player is in check given current @board set-up
    def in_check?
      #whose turn?
      @white ? color = "white" : color = "black"
      #where's king
      kings_sq = find_kings_position(color)
      #cycle through all pieces and see if their next move is a valid move on king  return true
      0.upto(7) do |y|
        0.upto(7) do |x|
           if (color == "white" && is_black?([y ,x]) )|| (color == "black" && is_white?([y ,x]) )
             if piece_can_move_there?([y ,x] , kings_sq)
               puts "In Check!"
               return true
             end
           end
        end
      end
    end



    #returns position of king for given color  -- Helper for in_check?
    def find_kings_position(color)
      color == "white"  ? piece = 9812 : piece = 9818
      0.upto(7) do |y|
        0.upto(7) { |x| return [y , x] if @board[y][x].ord == piece}
      end
    end




    #returns true if King can legally move: from...to
    def king_move(move_from, move_to)
        # invalid if king moves more than one space in any direction
        if (move_from[0] - move_to[0]).abs > 1 || (move_from[1] - move_to[1]).abs > 1
            return false
        end
        toggle_can_castle(move_from)
        true
    end


    #returns true if Queen can legally move: from...to
    def queen_move(move_from, move_to)
        # if a diagonal move then test it
        if (move_from[0] - move_to[0]).abs == (move_from[1] - move_to[1]).abs
            return !piece_in_path_diagonal?(move_from, move_to)
        end
        # if not linear or diagonal(see previous block) return false
        return false if move_to[0] != move_from[0] && move_to[1] != move_from[1]
        # if there is a NOT piece in the path return true
        !piece_in_path_straight?(move_from, move_to)
    end


    #returns true if Bishop can legally move: from...to
    def bishop_move(move_from, move_to)
        # not a diagonal move
        if (move_from[0] - move_to[0]).abs != (move_from[1] - move_to[1]).abs
            return false
        end
        # piece in path diagonal
        !piece_in_path_diagonal?(move_from, move_to)
    end


    #returns true if Knight can legally move: from...to
    def knight_move(move_from, move_to)
        # move is only valid if it is plus 2 and over 1 and not own piece at terminus
        if (move_from[0] - move_to[0]).abs == 2 && (move_from[1] - move_to[1]).abs == 1
            true
        elsif (move_from[0] - move_to[0]).abs == 1 && (move_from[1] - move_to[1]).abs == 2
            true
        else
            false
        end
    end


    #returns true if Rook can legally move: from...to
    def rook_move(move_from, move_to)
        # cases where move is not valid
        # diagonal
        return false if move_to[0] != move_from[0] && move_to[1] != move_from[1]
        # a piece in its path piece_in_path_straight
        return false if piece_in_path_straight?(move_from, move_to)
        toggle_can_castle(move_from)
        true
    end


    #returns true if a White Pawn can legally move: from...to
    def white_pawn_move(move_from, move_to)
        # Cases where move is not valid
        # check to see if legal, diagonal take occurs
        if move_to[0] == (move_from[0] + 1) && (move_from[1] == (move_to[1] + 1) || move_from[1] == (move_to[1] - 1))
            return is_take?(move_from, move_to)
        end
        # not the same column
        return false if move_to[1] != move_from[1]
        # if blocked by piece
        return false if is_white?(move_to) || is_black?(move_to)
        # more than 1 space forward  except from row 2
        return false if (move_to[0] != (move_from[0] + 1)) && move_from[0] != 1
        # move from row 2 is greater than 2
        return false if move_to[0] > move_from[0] + 2
        # a piece in its straight piece_in_path_straight
        return false if piece_in_path_straight?(move_from, move_to)
        true
    end


    #returns true if a Black Pawn can legally move: from...to
    def black_pawn_move(move_from, move_to)
        # Cases where move is not valid
        # check to see if legal, diagonal take occurs
        if move_to[0] == (move_from[0] - 1)
            if  move_from[1] == (move_to[1] + 1) || move_from[1] == (move_to[1] - 1)
              return  is_take?(move_from, move_to)
            end
        end
        # not the same column
        return false if move_to[1] != move_from[1]
        # if blocked by piece
        return false if is_white?(move_to) || is_black?(move_to)
        # more than 1 space forward  except from row 2
        return false if (move_to[0] != (move_from[0] - 1)) && move_from[0] != 6
        # move from row 2 is greater than 2
        return false if move_to[0] < move_from[0] - 2
        # a piece in its straight piece_in_path_straight
        return false if piece_in_path_straight?(move_from, move_to)
        true
    end



    #helper function for pawn diagonal moves
    #returns true if there is an opponent in the move_to square
    def is_take?(move_from, move_to)
        return is_black?(move_to) if is_white?(move_from)
        return is_white?(move_to) if is_black?(move_from)
    end



    #returns true if there is a piece blocking a diagonal move between move_from and move_to
    def piece_in_path_diagonal?(move_from, move_to)
        # sticking to matrix format where row axis is first element
        move_to[0] > move_from[0] ? increment_row = 1 : increment_row = -1
        move_to[1] > move_from[1] ? increment_col = 1 : increment_col = -1
        row = move_from[0].dup + increment_row
        col = move_from[1].dup + increment_col
        until row == move_to[0]
            return true if @board[row][col] != '.'
            row += increment_row
            col += increment_col
        end
        false
    end



    #returns true if there is a piece blocking a straight move between move_from and move_to
    def piece_in_path_straight?(move_from, move_to)
        if move_from[1] == move_to[1]
            col = move_from[1]
            # marks spot after or before piece
            start = move_from[0] < move_to[0] ? move_from[0] + 1 : move_to[0] + 1
            stop = move_from[0] < move_to[0] ? move_to[0] - 1 : move_from[0] - 1
            start.upto(stop) { |l| return true if @board[l][col] != '.' }
        else
            row = move_from[0]
            # marks spot after or before piece
            start = move_from[1] < move_to[1] ? move_from[1] + 1 : move_to[1] + 1
            stop = move_from[1] < move_to[1] ? move_to[1] - 1 : move_from[1] - 1
            start.upto(stop) { |l| return true if @board[row][l] != '.' }
         end
        false
    end

    # uses .ord to see if piece is in range of white or black pieces: see chart above.
    #returns true if square holds a White Piece
    def is_white?(sqr)
        (9812..9817).cover?(@board[sqr[0]][sqr[1]].ord)
    end

    #returns true if square holds a Black Piece
    def is_black?(sqr)
        (9818..9823).cover?(@board[sqr[0]][sqr[1]].ord)
    end



    #returns string 'UTF8 ' code for the given square or string '.'  if no piece is in the square
    def piece_at(sqr)
        @board[sqr[0]][sqr[1]]
    end


    #returns ascii value of item in square
    def ord_at(sqr)
        @board[sqr[0]][sqr[1]].ord
    end


    #loops until player choses their own piece to move_from
    #returns square/coords of piece
    def validate_move_from
        move_from = get_move
        # validate White's turn and white piece chosen or Black's turn and black piece chosen
        until (@white && is_white?(move_from)) || (!@white && is_black?(move_from))
            puts 'Invalid selection!  Try a different square:'
            move_from = get_move
        end
        move_from
    end



    #loops until player choses a square on the board
    #converts row[A-F], col[1-8]  to  0-7 , 0-7  in format [row, col]
    #returns row, col in [y ,x] format
    def get_move
        puts "Enter Square (e.g. a1)  --  R to Resign  --  S to Save"
        choice = 'XXX'
        scanned = choice.scan(/[a-h][1-8]/).join
        until choice.size == 2 && scanned.size == 2
            choice = gets.chomp
            # kill switch for testing
            exit(0) if choice == 'q' || choice == 'Q'
            scanned = choice.scan(/[a-h][1-8]/).join
        end
        # convert to coords on @board array
        #  -97  to get column  'a' = 97 ascii
        # @board format is [row][col]
        col = scanned[0].ord - 97
        row = scanned[1].to_i - 1
        [row, col]
    end


        #sorts by piece and directs to pieces move validation method
        #returns result from individual methods
        #returns true if piece can move: from...to
        def piece_can_move_there?(move_from, move_to)
          # test --- puts "in can move there   move_from: #{move_from}  move_to:#{move_to}"
          # selects chess piece
          case ord_at(move_from)
          when 9817
              return white_pawn_move(move_from, move_to)
          when 9823
              return black_pawn_move(move_from, move_to)
          when 9814, 9820
              return rook_move(move_from, move_to)
          when 9816, 9822
              return knight_move(move_from, move_to)
          when 9815, 9821
              return bishop_move(move_from, move_to)
          when 9813, 9819
              return queen_move(move_from, move_to)
          when 9812, 9818
              return king_move(move_from, move_to)
          else
              puts 'Something went terribly wrong in can-move-there?'
          end
        end


    #-------------CASTLING----------  THEN END

    def can_castle?(move_from, move_to)
      #make sure lane is empty first
      return false if piece_in_path_straight?(move_from, move_to)
      #check each of four possible moves to make sure piece hasn't already been moved
      if ord_at(move_from) == 9814 && move_from == [0, 0] && ord_at(move_to) == 9812
          return @white_qr_can_castle
      elsif ord_at(move_from) == 9814 && move_from == [0, 7] && ord_at(move_to) == 9812
          return @white_kr_can_castle
      elsif ord_at(move_from) == 9820 && move_from == [7, 0] && ord_at(move_to) == 9818
          return @black_qr_can_castle
      elsif ord_at(move_from) == 9820 && move_from == [7, 7] && ord_at(move_to) == 9818
          return @black_kr_can_castle
      elsif ord_at(move_from) == 9812 && move_from == [0, 4] && move_to == [0,0]
          return @white_qr_can_castle
      elsif ord_at(move_from) == 9812 && move_from == [0, 4] && move_to == [0,7]
          return @white_kr_can_castle
      elsif ord_at(move_from) == 9818 && move_from == [7, 4] && move_to == [7,0]
          return @black_qr_can_castle
        elsif ord_at(move_from) == 9818 && move_from == [7, 4] && move_to == [7,7]
          return @black_kr_can_castle
      end
      false
    end

    #if rook or king is moved from their starting position castling becomes invalid
    def toggle_can_castle(move_from)
        if ord_at(move_from) == 9814 && move_from == [0, 0]
            @white_qr_can_castle = false
        elsif ord_at(move_from) == 9814 && move_from == [0, 7]
            @white_kr_can_castle = false
        elsif ord_at(move_from) == 9820 && move_from == [7, 0]
            @black_qr_can_castle = false
        elsif ord_at(move_from) == 9820 && move_from == [7, 7]
            @black_kr_can_castle = false
        elsif ord_at(move_from) == 9812 && move_from == [0, 4]
            @white_kr_can_castle = false
            @white_qr_can_castle = false
        elsif ord_at(move_from) == 9818 && move_from == [7, 4]
            @black_kr_can_castle = false
            @black_qr_can_castle = false
        end
    end


end
