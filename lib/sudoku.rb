# 解が見つかったらtrueを返す。解無しならfalseを返す
def solve(board)
  if board.full?
    return board.solved?
  end

  (0...9).each do |j|
    (0...9).each do |i|
      if board.at(i, j) == Board::BLANK
        used_numbers = board.used_numbers_in_row(j) + board.used_numbers_in_column(i) + board.used_numbers_in_same_block(i, j)
        candidates = board.not_used_numbers(used_numbers)
        return false if candidates.empty? # 候補がなかったら解無し
        candidates.each do |num|
          saved = board.at(i, j)
          board.put(i, j, num)
          puts
          board.print
          if solve(board)
            return true
          end
          board.put(i, j, saved)
        end
        return false  # どの候補でも解が見つからなかったら解無し
      end
    end
  end
  return false  # 到達しない。念の為
end

class Board
  BLANK = 0 # board.txtで"."で表されるマスは空白。データ上では数値の0で表現する。
  SIZE = 9
  BLOCK_SIZE = SIZE / 3

  def self.load(filename)
    data = []
    open(filename) do |f|
      f.each do |line|
        data += line.chomp.split('').map(&:to_i)
      end
    end
    Board.new(data)
  end

  def initialize(data)
    @data = data
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
  if solve(Board.load('data/board.txt'))
    puts
    puts "Solved!"
  else
    puts
    puts "Solution not found."
  end
end
