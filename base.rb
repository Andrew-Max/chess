require 'pry'

class Game
  attr_accessor :pieces
  HEIGHT = 8
  WIDTH = 8
  PIECE_ARRAY = ["bishop", "knight", "rook", "queen", "king", "pawn"]

  def initialize
    initialize_pieces
  end

  private

  def initialize_pieces
    @pieces = { white: {}, black: {}}

    PIECE_ARRAY.each do |piece|
      klass = Kernel.const_get(piece.capitalize)
      klass.initial_x.each { |x| create_pieces_for_both_colors(klass, x) }
    end
  end

  def create_pieces_for_both_colors(klass, x)
    create_piece_for_color(klass, x, :black)
    create_piece_for_color(klass, x, :white)
  end

  def create_piece_for_color(klass, x, color)
    coord = Coord.new(x, klass::INITIAL_Y[color])
    piece = klass.new(coord, color)
    add_to_pieces(klass, color, piece)
  end

  def add_to_pieces(klass, color, piece)
    piece_key = klass.name.downcase.to_sym
    @pieces[color][piece_key] = [] unless @pieces[color][piece_key]
    @pieces[color][piece_key].push(piece)
  end
end

class Piece
  attr_accessor :coord
  attr_reader :color

  def initialize(coord, color)
    @location = coord
    @color = color
  end
end

class Coord
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Court < Piece
  INITIAL_Y = { white: 1, black: 8}
end

class Pawn < Piece
  INITIAL_Y = { white: 2, black: 7}

  def self.initial_x
    1..8
  end
end

class Royal < Court; end;

class Bishop < Court
  def self.initial_x
    [3, 5]
  end
end

class Rook < Court
  def self.initial_x
    [1, 8]
  end
end

class Knight < Court
  def self.initial_x
    [2, 7]
  end
end

class Queen < Royal
  def self.initial_x
    @color == :white ? [4] : [5]
  end
end

class King < Royal
  def self.initial_x
    @color == :white ? [5] : [4]
  end
end
