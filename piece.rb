class Piece
  attr_accessor :r, :c, :type, :color, :unicode

  def initialize(row, column, type, color)
    @r = row
    @c = column
    @type = type #redundant?
    @color = color
    @container = []
    unicode
  end

  def unicode
    # include a user option to turn unicode on and off
    piece = self.class.to_s

    case piece

    when "Pawn"
      @color == "w" ? @unicode = "\u265F" : @unicode = "\u2659"
    when "King"
      # NOTE: Some fonts incorrectly reverse the King's black and white unicode.
      @color == "w" ? @unicode = "\u265A" : @unicode = "\u2654"
    when "Queen"
      @color == "w" ? @unicode = "\u265B" : @unicode = "\u2655"
    when "Bishop"
      @color == "w" ? @unicode = "\u265D" : @unicode = "\u2657"
    when "Knight"
      @color == "w" ? @unicode = "\u265E" : @unicode = "\u2658"
    when "Rook"
      @color == "w" ? @unicode = "\u265C" : @unicode = "\u2656"
    end
  end

  private
  
    def on_board?(coord)
      coord[0] <= 7 && coord[1] <= 7 &&
      coord[0] >= 0 && coord[1] >= 0
    end

    def occupied?(move, game)
      game.board[move[0]][move[1]] != " " &&
      game.board[move[0]][move[1]].color == @color
    end

    def can_take_piece?(square)
      if square.is_a?(Piece)
        if square.color != @color then @container << [square.r, square.c] end
        true
      else
        false
      end
    end
end