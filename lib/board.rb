# frozen_string_literal: true

# rubocop: disable Metrics/ClassLength
# represents the chess board
class Board
  def initialize
    # the board is represented by an array of 8 subarrays, each
    # subarray representing a row, starting from the bottom.
    # The index value represents [row][column], ie the cell
    # at [0,3] is d1 (or White Queen)
    @board_state = [[], [], [], [], [], [], [], []]
    build_starting_board
  end

  attr_reader :board_state

  # rubocop : disable Metrics/MethodLength
  # using to test board creation and changes. May end up transforming into the
  # display board method
  def pretty_print_board
    @board_state.each_with_index do |row, index|
      print "rank #{index + 1}: "
      row.each do |cell|
        if cell.contents.nil?
          print "#{cell.position} empty "
        else
          print "#{cell.position} #{cell.contents.color} #{cell.contents.type} "
        end
      end
      puts ''
    end
  end
  # rubocop : enable Metrics/MethodLength

  def create_valid_destination_list(piece_type, starting_row_index, starting_column_index)
    case piece_type
    when 'Rook'
      create_rook_valid_destination_list(starting_row_index, starting_column_index)
    when 'Knight'
      create_knight_valid_destination_list(starting_row_index, starting_column_index)
    when 'Bishop'
      create_bishop_valid_destination_list(starting_row_index, starting_column_index)
    when 'Queen'
      create_queen_valid_destination_list(starting_row_index, starting_column_index)
    when 'King'
      create_king_valid_destination_list(starting_row_index, starting_column_index)
    end
  end

  private

  def build_starting_board
    place_white_starting_pieces
    fill_empty_cells_for_starting_board
    place_black_starting_pieces
  end

  def place_white_starting_pieces
    place_piece('a', 1, 'White', 'Rook')
    place_piece('b', 1, 'White', 'Knight')
    place_piece('c', 1, 'White', 'Bishop')
    place_piece('d', 1, 'White', 'Queen')
    place_piece('e', 1, 'White', 'King')
    place_piece('f', 1, 'White', 'Bishop')
    place_piece('g', 1, 'White', 'Knight')
    place_piece('h', 1, 'White', 'Rook')
    place_white_starting_pawns
  end

  def place_piece(column, row, color, type)
    @board_state[row - 1] << Cell.new("#{column}#{row}", Piece.new(color, type))
  end

  def place_white_starting_pawns
    place_piece('a', 2, 'White', 'Pawn')
    place_piece('b', 2, 'White', 'Pawn')
    place_piece('c', 2, 'White', 'Pawn')
    place_piece('d', 2, 'White', 'Pawn')
    place_piece('e', 2, 'White', 'Pawn')
    place_piece('f', 2, 'White', 'Pawn')
    place_piece('g', 2, 'White', 'Pawn')
    place_piece('h', 2, 'White', 'Pawn')
  end

  def fill_empty_cells_for_starting_board
    fill_empty_cells_in_row(3)
    fill_empty_cells_in_row(4)
    fill_empty_cells_in_row(5)
    fill_empty_cells_in_row(6)
  end

  def fill_empty_cells_in_row(row)
    place_empty_cell(row, 'a')
    place_empty_cell(row, 'b')
    place_empty_cell(row, 'c')
    place_empty_cell(row, 'd')
    place_empty_cell(row, 'e')
    place_empty_cell(row, 'f')
    place_empty_cell(row, 'g')
    place_empty_cell(row, 'h')
  end

  def place_empty_cell(row, column)
    @board_state[row - 1] << Cell.new("#{column}#{row}")
  end

  def place_black_starting_pieces
    place_black_starting_pawns
    place_piece('a', 8, 'Black', 'Rook')
    place_piece('b', 8, 'Black', 'Knight')
    place_piece('c', 8, 'Black', 'Bishop')
    place_piece('d', 8, 'Black', 'Queen')
    place_piece('e', 8, 'Black', 'King')
    place_piece('f', 8, 'Black', 'Bishop')
    place_piece('g', 8, 'Black', 'Knight')
    place_piece('h', 8, 'Black', 'Rook')
  end

  def place_black_starting_pawns
    place_piece('a', 7, 'Black', 'Pawn')
    place_piece('b', 7, 'Black', 'Pawn')
    place_piece('c', 7, 'Black', 'Pawn')
    place_piece('d', 7, 'Black', 'Pawn')
    place_piece('e', 7, 'Black', 'Pawn')
    place_piece('f', 7, 'Black', 'Pawn')
    place_piece('g', 7, 'Black', 'Pawn')
    place_piece('h', 7, 'Black', 'Pawn')
  end

  def create_rook_valid_destination_list(starting_row_index, starting_column_index)
    rook_destinations = []
    for i in 0..7 do
      rook_destinations << [i, starting_column_index]
    end
    for i in 0..7 do
      rook_destinations << [starting_row_index, i]
    end
    rook_destinations.delete [starting_column_index, starting_row_index]
    rook_destinations
  end

  def create_knight_valid_destination_list(starting_row_index, starting_column_index)
    knight_destinations = []
    r = starting_row_index
    c = starting_column_index
    knight_destinations << [r - 2, c + 1] if valid_position?(r - 2, c + 1)
    knight_destinations << [r - 1, c + 2] if valid_position?(r - 1, c + 2)
    knight_destinations << [r + 1, c + 2] if valid_position?(r + 1, c + 2)
    knight_destinations << [r + 2, c + 1] if valid_position?(r + 2, c + 1)
    knight_destinations << [r + 2, c - 1] if valid_position?(r + 2, c - 1)
    knight_destinations << [r + 1, c - 2] if valid_position?(r + 1, c - 2)
    knight_destinations << [r - 1, c - 2] if valid_position?(r - 1, c - 2)
    knight_destinations << [r - 2, c - 1] if valid_position?(r - 2, c - 1)
    knight_destinations
  end

  def valid_position?(row_index, column_index)
    return false if row_index.negative? || row_index > 7 || column_index.negative? || column_index > 7

    true
  end

  # iterative approach to build this. Could probably have gone recursive instead
  def create_bishop_valid_destination_list(starting_row_index, starting_column_index)
    bishop_destinations = add_diagonal_down_right_destinations(starting_row_index, starting_column_index)

    bishop_destinations += add_diagonal_up_right_destinations(starting_row_index, starting_column_index)

    bishop_destinations += add_diagonal_up_left_destinations(starting_row_index, starting_column_index)

    bishop_destinations += add_diagonal_down_left_destinations(starting_row_index, starting_column_index)

    bishop_destinations
  end

  def add_diagonal_down_right_destinations(starting_row_index, starting_column_index)
    destinations = []
    r = starting_row_index
    c = starting_column_index
    until r == 0 || r == 7 || c == 0 || c == 7
      destinations << [r - 1, c + 1]
      r = r - 1
      c = c + 1
    end
    destinations
  end

  def add_diagonal_up_right_destinations(starting_row_index, starting_column_index)
    destinations = []
    r = starting_row_index
    c = starting_column_index
    until r == 0 || r == 7 || c == 0 || c == 7 do
      destinations << [r + 1, c + 1]
      r = r + 1
      c = c + 1
    end
    destinations
  end

  def add_diagonal_up_left_destinations(starting_row_index, starting_column_index)
    destinations = []
    r = starting_row_index
    c = starting_column_index
    until r == 0 || r == 7 || c == 0 || c == 7 do
      destinations << [r + 1, c - 1]
      r = r + 1
      c = c -1
    end
    destinations
  end

  def add_diagonal_down_left_destinations(starting_row_index, starting_column_index)
    destinations = []
    r = starting_row_index
    c = starting_column_index
    until r == 0 || r == 7 || c == 0 || c == 7 do
      destinations << [r - 1, c - 1]
      r = r - 1
      c = c -1
    end
    destinations
  end

  def create_queen_valid_destination_list(starting_row_index, starting_column_index)
    rook_destinations = create_rook_valid_destination_list(starting_row_index, starting_column_index)
    bishop_destinations = create_bishop_valid_destination_list(starting_row_index, starting_column_index)
    queen_destinations = rook_destinations + bishop_destinations
    queen_destinations
  end

  def create_king_valid_destination_list(starting_row_index, starting_column_index)
    king_destinations = []
    r = starting_row_index
    c = starting_column_index
    king_destinations << [r - 1, c] if valid_position?(r - 1, c)
    king_destinations << [r - 1, c + 1] if valid_position?(r - 1, c + 1)
    king_destinations << [r, c + 1] if valid_position?(r, c + 1)
    king_destinations << [r + 1, c + 1] if valid_position?(r + 1, c + 1)
    king_destinations << [r + 1, c] if valid_position?(r + 1, c)
    king_destinations << [r + 1, c - 1] if valid_position?(r + 1, c - 1)
    king_destinations << [r, c - 1] if valid_position?(r, c - 1)
    king_destinations << [r - 1, c - 1] if valid_position?(r - 1, c - 1)
    king_destinations
  end
end
# rubocop: enable Metrics/ClassLength
