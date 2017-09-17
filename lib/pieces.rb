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

    # this will be a switch and will return move_to if it is valid
    def validate_move_to(move_from, move_to)
        #automatically invalid if own piece at terminus --covers selecting same square --exception  Castling
        if (is_white?(move_from) && is_white?(move_to)) || (is_black?(move_from) && is_black?(move_to))
          puts "cannot move onto own piece!"
          return false unless can_castle?(move_from, move_to)
        end
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
            puts 'Error in validate_move_to'
        end
    end

    def king_move(move_from, move_to)
      #invalid if king moves more than one space in any direction
      if (move_from[0] - move_to[0]).abs > 1 || (move_from[1] - move_to[1]).abs > 1
        return false
      end
      true
    end

    def queen_move(move_from, move_to)
      #if a diagonal move then test it
      if (move_from[0] - move_to[0]).abs == (move_from[1] - move_to[1]).abs
        return !piece_in_path_diagonal?(move_from, move_to)
      end
      #if not linear or diagonal(see previous block) return false
      return false if move_to[0] != move_from[0] && move_to[1] != move_from[1]
      #if there is a NOT piece in the path return true
      !piece_in_path_straight?(move_from, move_to)
    end

    def bishop_move(move_from, move_to)
      #not a diagonal move
      if (move_from[0] - move_to[0]).abs != (move_from[1] - move_to[1]).abs
        return false
      end
      #piece in path diagonal
      !piece_in_path_diagonal?(move_from, move_to)
    end

    def knight_move(move_from, move_to)
      #move is only valid if it is plus 2 and over 1 and not own piece at terminus
      if (move_from[0] - move_to[0]).abs == 2 && (move_from[1] - move_to[1]).abs == 1
        return true
      elsif (move_from[0] - move_to[0]).abs == 1 && (move_from[1] - move_to[1]).abs == 2
        return true
      else
        return false
      end
    end

    def can_castle?(move_from, move_to)
      return false
    end


    def rook_move(move_from, move_to)
        puts 'moving a rook'
        #cases where move is not valid
        #diagonal
        return false if move_to[0] != move_from[0] && move_to[1] != move_from[1]
        # a piece in its path piece_in_path_straight
        return false if piece_in_path_straight?(move_from, move_to)
        true
    end

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

    def black_pawn_move(move_from, move_to)
        # Cases where move is not valid
        # check to see if legal, diagonal take occurs
        if move_to[0] == (move_from[0] - 1) && (move_from[1] == (move_to[1] + 1) || move_from[1] == (move_to[1] - 1))
            return is_take?(move_from, move_to)
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

    def is_take?(move_from, move_to)
        return is_black?(move_to) if is_white?(move_from)
        return is_white?(move_to) if is_black?(move_from)
    end


    def piece_in_path_diagonal?(move_from, move_to)
      #sticking to matrix format where row axis is first element
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


    def piece_in_path_straight?(move_from, move_to)
        if move_from[1] == move_to[1]
          col= move_from[1]
          # marks spot after or before piece
          start = move_from[0] < move_to[0] ? move_from[0] + 1 : move_to[0] + 1
          stop = move_from[0] < move_to[0] ? move_to[0] - 1 : move_from[0] - 1
          start.upto(stop) {|l| return true if @board[l][col] != '.'}
         else
           row = move_from[0]
           # marks spot after or before piece
           start = move_from[1] < move_to[1] ? move_from[1] + 1 : move_to[1] + 1
           stop = move_from[1] < move_to[1] ? move_to[1] - 1 : move_from[1] - 1
           start.upto(stop) { |l| return true if @board[row][l] != '.'}
         end
         false
    end

    # using .ord to see if piece is in range of white or black pieces see chart above.
    def is_white?(sqr)
        (9812..9817).cover?(@board[sqr[0]][sqr[1]].ord)
    end

    def is_black?(sqr)
        (9818..9823).cover?(@board[sqr[0]][sqr[1]].ord)
    end

    def piece_at(sqr)
        @board[sqr[0]][sqr[1]]
    end

    def ord_at(sqr)
        @board[sqr[0]][sqr[1]].ord
    end

    def validate_move_from
        move_from = get_move
        # validate White's turn and white piece chosen or Black's turn and black piece chosen
        until (@white && is_white?(move_from)) || (!@white && is_black?(move_from))
            puts 'Invalid selection!'
            puts 'Try a different square:'
            move_from = get_move
        end
        move_from
    end



    def get_move
        choice = 'XXX'
        scanned = choice.scan(/[a-h][1-8]/).join
        until choice.size == 2 && scanned.size == 2
            choice = gets.chomp
            # kill switch for testing
            exit(0) if choice == 'q'
            scanned = choice.scan(/[a-h][1-8]/).join
        end
        # convert to coords on @board array
        #  -97  to get column  'a' = 97 ascii
        # @board format is [row][col]
        col = scanned[0].ord - 97
        row = scanned[1].to_i - 1
        [row, col]
    end
end
