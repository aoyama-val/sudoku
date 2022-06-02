require_relative '../lib/sudoku.rb'

describe 'Sudoku'do
  describe 'Board' do
    let(:board) { Board.new('./data/board.txt') }

    describe '#used_numbers_in_row' do
      it '指定された行で使われている数の配列が昇順で返る' do
        expect(board.used_numbers_in_row(1)).to eq [6, 9]
      end
    end

    describe '#used_numbers_in_column' do
      it '指定された列で使われている数の配列が昇順で返る' do
        expect(board.used_numbers_in_column(0)).to eq [1, 4, 5, 7, 8]
      end
    end

    describe '#not_used_numbers' do
      it '指定された列で使われている数の配列が昇順で返る' do
        expect(board.not_used_numbers([3, 1, 4])).to eq [2, 5, 6, 7, 8, 9]
      end
    end
  end
end