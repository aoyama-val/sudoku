class Solver
  # def initialize(board_filename)
  #   @board = Board.new(board_filename)
  #   @board.print
  # end

  def solve(board)
    return if board.full?

    (0...9).each do |j|
      (0...9).each do |i|
        if board.at(i, j) == Board::BLANK
          used_numbers = board.used_numbers_in_row(j) + board.used_numbers_in_column(i) + board.used_numbers_in_same_block(i, j)
          candidates = board.not_used_numbers(used_numbers)
          # print "Can put #{i}, #{j}: "
          # p candidates
          return false if candidates.empty?
          candidates.each do |num|
            cloned = board.clone
            cloned.put(i, j, num)
            puts
            cloned.print
            if cloned.solved?
              puts
              cloned.print
              puts "Solved!"
              return true
            end
            if solve(cloned)
              return true
            end
          end
          return false
        end
      end
    end
    return false
  end
end

class Board
  BLANK = 0 # board.txtで"."で表されるマスは空白。データ上では数値の0で表現する。
  SIZE = 9
  BLOCK_SIZE = SIZE / 3

  attr_accessor :data

  def initialize(board_filename)
    @data = []
    open(board_filename) do |f|
      f.each do |line|
        @data += line.chomp.split('').map(&:to_i)
      end
    end
    validate!
  end

  def clone
    old_data = @data.clone
    cloned = super
    cloned.data = old_data
    cloned
  end

  def print
    @data.each_slice(SIZE) do |slice|
      puts slice.map { |num| num == BLANK ? '. ' : "#{num} " }.join('')
    end
  end

  def validate!
    raise "InvalidBoardError length=#{@data.length}" if @data.length != SIZE ** 2
  end

  # ブロック番号を返す
  def block(i, j)
    i / BLOCK_SIZE + (j / BLOCK_SIZE) * BLOCK_SIZE
  end

  def used_numbers_in_same_block(i, j)
    used_numbers_in_block(block(i, j))
  end

  def at(i, j)
    @data[j * SIZE + i]
  end

  def put(i, j, num)
    @data[j * SIZE + i] = num
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

  def full?
    @data.all? { |num| num != Board::BLANK }
  end
end

if $0 == __FILE__
  Solver.new.solve(Board.new('data/board.txt'))
end
