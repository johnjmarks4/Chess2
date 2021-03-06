require 'C:\Users\johnj\odin-project\chess\lib\board.rb'
require 'C:\Users\johnj\odin-project\chess\lib\queen.rb'
require 'C:\Users\johnj\odin-project\chess\lib\king.rb'
require 'C:\Users\johnj\odin-project\chess\lib\pawn.rb'
require 'C:\Users\johnj\odin-project\chess\lib\bishop.rb'
require 'C:\Users\johnj\odin-project\chess\lib\rook.rb'
require 'C:\Users\johnj\odin-project\chess\lib\knight.rb'

describe Board do

  let(:board) { Board.new }

  describe "#board" do

    it "recognizes fool's mate" do
      board.board[1][5] = " "
      board.board[1][6] = " "
      board.board[2][5] = Pawn.new(2, 5, "w", board)
      board.board[3][6] = Pawn.new(3, 6, "w", board)
      board.board[3][7] = Queen.new(3, 7, "b", board)
      king = board.board[0][4]
      board.instance_variable_set("@turn", "w")
      board.instance_variable_set("@w_king", king)

      expect(board.checkmate?).to eql(true)
    end

    it "recognizes checkmate" do
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      king = King.new(2, 2, "b", board)
      board.board[2][2] = king
      board.board[3][2] = Bishop.new(3, 2, "w", board)
      board.board[4][3] = Bishop.new(4, 3, "w", board)
      board.board[5][2] = Knight.new(5, 2, "w", board)
      board.board[1][5] = Rook.new(1, 5, "w", board)
      board.board[0][2] = Rook.new(0, 2, "w", board)

      board.instance_variable_set("@turn", "b")
      board.instance_variable_set("@b_king", king)

      expect(board.checkmate?).to eql(true)
    end

    it "tells player if king in check" do
      board = Board.new
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      board.instance_variable_set("@turn", "b")
      king = King.new(4, 7, "b", board)
      board.board[4][7] = king
      board.instance_variable_set("@b_king", king)
      board.board[4][0] = Rook.new(4, 0, "w", board)

      expect(board.in_check?).not_to eql(false)
    end

    it "recognizes if checked player can shield king" do
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      board.board[2][6] = Pawn.new(2, 6, "w", board)
      board.board[5][0] = Rook.new(5, 0, "b", board)
      king = King.new(4, 7, "b", board)
      board.board[4][7] = king
      white_king = King.new(4, 5, "w", board)
      board.board[4][5] = white_king
      white_knight = Knight.new(4, 4, "w", board)
      board.board[4][4] = white_knight
      board.board[6][5] = Bishop.new(6, 5, "w", board)
      board.board[6][7] = Bishop.new(6, 7, "b", board)

      board.instance_variable_set("@b_king", king)
      board.instance_variable_set("@w_king", white_king)
      board.instance_variable_set("@white_knight1", white_knight)

      expect(board.checkmate?).to eql(false)
    end

    it "recognizes if king can take checker" do
      board = Board.new
      board.board[6][3] = Pawn.new(6, 3, "w", board)
      board.instance_variable_set("@turn", "b")

      expect(board.in_check?).not_to eql(false)
      expect(board.checkmate?).to eql(false)
    end

    it "recognizes if king can be shielded from knight" do
      board = Board.new
      board.set_board
      board.board[5][3] = Knight.new(5, 3, "w", board)
      board.instance_variable_set("@turn", "b")

      expect(board.in_check?).not_to eql(false)
      expect(board.checkmate?).to eql(false)
    end

    before do
      $stdin = StringIO.new("1a")
    end

    after do
      $stdin = STDIN
    end

    it "recognizes opportunity to castle" do
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      board.board[1][0] = Pawn.new(0, 0, "w", board)
      board.board[0][0] = Rook.new(0, 0, "w", board)

      king = King.new(0, 4, "w", board)
      board.board[0][4] = king
      board.instance_variable_set("@turn", "w")
      board.print_board
      board.testing = true

      expect(STDOUT).to receive(:puts).with("\nPlayer w, please select the piece you would like to move.").at_least(:once)
      expect(STDOUT).to receive(:puts).with("Rook w can make the following moves:\n\n [\"1b\", \"1c\", \"1d\", \"castle\"]\n").once
      expect(STDOUT).to receive(:puts).with("Please select your move, or type 'cancel' to select another piece.").once
      board.move
    end

    it "recognizes en passant" do
      board = Board.new
      board.board[5][3] = Pawn.new(5, 3, "w", board)
      pawn1 = Pawn.new(5, 4, "b", board)
      pawn1.instance_variable_set("@moves", "1")
      board.board[5][4] = pawn1
      pawn2 = Pawn.new(5, 2, "b", board)
      pawn2.instance_variable_set("@moves", "1")
      board.board[5][2] = pawn2
      board.instance_variable_set("@turn", "w")

      expect(board.board[5][3].show_moves).to include [6, 2]
      expect(board.board[5][3].show_moves).to include [6, 4]
    end
  end
end