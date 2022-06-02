class Solver
  def solve(board_filename)
    @board = Board.new(board_filename)
    @board.print
  end
end

class Board
  BLANK = 0 # board.txtで"."で表されるマスは空白。データ上では数値の0で表現する。
  SIZE = 9
  BLOCK_SIZE = SIZE / 3

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

  def used_numbers_in_block(n)
    nums = []
    top_left_i = (n % BLOCK_SIZE) * BLOCK_SIZE
    top_left_j = (n / BLOCK_SIZE) * BLOCK_SIZE
    (0...3).each do |i|
      (0...3).each do |j|
        num = at(top_left_i + i, top_left_j + j)
        nums << num if num != BLANK
      end
    end
    nums.sort.uniq
  end

  def not_used_numbers(used_numbers)
    (1..SIZE).to_a - used_numbers
  end

  def solved?
    (0...SIZE).all? { |i| used_numbers_in_row(i).length == SIZE } &&
    (0...SIZE).all? { |i| used_numbers_in_column(i).length == SIZE } &&
    (0...SIZE).all? { |i| used_numbers_in_block(i).length == SIZE}
  end
end

Solver.new.solve('data/board.txt')
