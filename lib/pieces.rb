class Piece

=begin
Unicode for chess pieces:
White Pawn   =   "\u2659"      Black Pawn   =  "\u265f"
White Rook   =   "\u2658"      Black Rook   =  "\u265c"
White Knight =   "\u2656"      Black Knight =  "\u265e"
White Bishop =   "\u2657"      Black Bishop =  "\u265d"
White Queen  =   "\u2655"      Black Queeen =  "\u265b"
White King   =   "\u2654"      Black King   =  "\u265a"
=end

  attr_reader :type

    def intialize(type)
      @type = type
    end







end
