require 'pry'

class Game
  attr_accessor :pieces, :current_mover, :moves

  HEIGHT = 8
  WIDTH = 8
  PIECE_ARRAY = ["bishop", "knight", "rook", "queen", "king", "pawn"]

  def initialize
    initialize_pieces
    @current_mover = :white
  end

  def turn(piece, coord)
    raise if piece.color != @current_mover
    piece.move(coord)
    toggle_mover
  end

  private

  def toggle_mover
    @current_mover == :white ? :black : :white
  end

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

class Coord
  attr_accessor :x, :y

  def self.is_valid(coord)
    raise unless coord.x >=1 && coord.x <= 8 && coord.y >=1 coord.y <= 8
  end

  def self.not_taken_by_same_color(coord, color)
    # implement
  end

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Piece
  attr_accessor :location, :status
  attr_reader :color

  def initialize(coord, color)
    @location = coord
    @color = color
    @status = :alive
  end

  def x
    @location.x
  end

  def y
    @location.y
  end

  def kill
    @status = :dead
  end

  def move(coord)
    if can_move_to_coord(coord)
      @location = coord
    else
      raise
    end
  end

  private

  def can_move_to_coord(coord)
    Coord.is_valid(coord)
    Coord.not_taken_by_same_color(coord, @color)
  end

  def one_away(n1, n2)
    (n1 - n2).abs == 1
  end
end

class Court < Piece
  INITIAL_Y = { white: 1, black: 8}
end

class Pawn < Piece
  @attr_accessor = :acts_as_queen
  INITIAL_Y = { white: 2, black: 7}

  def self.initial_x
    1..8
  end

  def initialize
    super
    @acts_as_queen = false
  end

  def can_move_to_coord(coord)
    super

    if @acts_as_queen
      Queen.can_move_to_coord(self.location, coord))
    else
      coord.y == @y + 1 && coord.x == @x
    end
  end

  def upgrade
    @acts_as_queen = true
  end
end


class Bishop < Court
  def self.initial_x
    [3, 5]
  end

  def can_move_to_coord(coord)
    super
  end
end

class Rook < Court
  def self.initial_x
    [1, 8]
  end

  def can_move_to_coord(coord)
    super
  end
end

class Knight < Court
  def self.initial_x
    [2, 7]
  end

  def can_move_to_coord(coord)
    super

    is_valid_el(coord)
  end

  private

  def is_valid_el(coord)
    if two_away(@location.x, coord.x)
      raise unless one_away(@location.y, coord.y)
    elsif one_away(@location.x, coord.x)
      raise unless two_away(@location.y, coord.y)
    else
      raise
    end
  end

  def two_away(n1, n2)
    (n1 - n2).abs == 2
  end
end

class Queen < Royal
  def self.initial_x
    @color == :white ? [4] : [5]
  end

  def self.can_move_to_coord(from, to)

  end

  def can_move_to_coord(coord)
    super
  end
end

class King < Royal
  def self.initial_x
    @color == :white ? [5] : [4]
  end

  def can_move_to_coord(coord)
    super
    raise if @location.x == coord.x && @location.y == coord.y
    raise unless one_or_none_away(@location.y, coord.y)
    raise unless one_or_none_away(@location.x, coord.x)
  end

  def one_or_none_away(n1, n2)
    val = (n1 - n2).abs
    [0, 1].include?(val)
  end
end
