require_relative 'piece'

class Pawn < Piece

  def show_moves
    moves = []

    if on_board?([@r + 1, @c])
      moves << [@r + 1, @c] if @color == "w" && !@board.board[@r+1][@c].is_a?(Piece)
    elsif on_board?([@r - 1, @c])
      moves << [@r - 1, @c] if @color == "b" && !@board.board[@r-1][@c].is_a?(Piece)
    end

    if starting_position?
      moves << [@r + 2, @c] if @color == "w" && !occupied?([@r + 1, @c])
      moves << [@r - 2, @c] if @color == "b" && !occupied?([@r - 1, @c])
    end

    diagonals = [[@r + 1, @c + 1], [@r + 1, @c - 1]] if @color == "w"
    diagonals = [[@r - 1, @c + 1], [@r - 1, @c - 1]] if @color == "b"
    diagonals.each do |m|
      next if m.any? { |n| n > 7 || n < 0 }
      square = @board.board[m[0]][m[1]]
      moves << m if can_take_piece?(square)
    end

    moves.reject! { |m| occupied?(m) }
    moves
  end

  def promote
    if @r == 7 || @r == 0
      print "One of your pawns has reached the back row. Type the letter for the piece \n
      you would like to trade it for: \nq = Queen\nb = Bishop\nk = Knight\nr = Rook\n"

      input = gets.chomp

      case input
      when "q"
        @board.board[@r][@c] = Queen.new(@r, @c, "q", @color, @board)
      when "b"
        @board.board[@r][@c] = Bishop.new(@r, @c, "b", @color, @board)
      when "k"
        @board.board[@r][@c] = Knight.new(@r, @c, "h", @color, @board)
      when "r"
        @board.board[@r][@c] = Rook.new(@r, @c, "r", @color, @board)
      else
        puts "Your input was not understood."
        promote(@board)
      end
    end
  end

  private
  
    def starting_position?
      if @color == "b" 
        @r == 6
      elsif @color == "w" 
        @r == 1
      end
    end
end