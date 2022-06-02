class Solver
  def solve(board_filename)
    @board = Board.new(board_filename)
    @board.print
  end
end

class Board
  BLANK = 0
  SIZE = 9

  def initialize(board_filename)
    @data = []
    open(board_filename) do |f|
      f.each do |line|
        @data += line.chomp.split('').map(&:to_i)
      end
    end
    validate!
  end

  def print
    @data.each_slice(SIZE) do |slice|
      puts slice.map { |num| num == BLANK ? '. ' : "#{num} " }.join('')
    end
  end

  def validate!
    raise "InvalidBoardError length=#{@data.length}" if @data.length != SIZE ** 2
  end

  def at(i, j)
    @data[j * SIZE + i]
  end

  def row(i)
    (0...SIZE).map { |j| at(j, i)}
  end

  def column(i)
    (0...SIZE).map { |j| at(i, j)}
  end

  def used_numbers_in_row(i)
    row(i).reject { |x| x == BLANK }.sort.uniq
  end

  def used_numbers_in_column(i)
    column(i).reject { |x| x == BLANK }.sort.uniq
  end

  def not_used_numbers(used_numbers)
    (1..SIZE).to_a - used_numbers
  end
end

Solver.new.solve('data/board.txt')
