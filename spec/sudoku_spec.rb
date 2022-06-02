require_relative '../lib/sudoku.rb'

describe 'Sudoku'do
  describe 'Board' do
    let(:board) { Board.load('./data/board.txt') }

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

    describe '#used_numbers_in_block' do
      it '指定されたブロックで使われている数の配列が昇順で返る' do
        expect(board.used_numbers_in_block(4)).to eq [1, 2, 3, 5, 7, 8]
      end

      it '指定されたブロック(5)で使われている数の配列が昇順で返る' do
        expect(board.used_numbers_in_block(5)).to eq [2, 3, 4, 6, 9]
      end
    end

    describe '#not_used_numbers' do
      it '指定された列で使われている数の配列が昇順で返る' do
        expect(board.not_used_numbers([3, 1, 4])).to eq [2, 5, 6, 7, 8, 9]
      end
    end

    describe '#solved?' do
      context 'ボードが正解でない状態の場合' do
        it 'falseが返る' do
          expect(board.solved?).to eq false
        end
      end

      context 'ボードが正解の状態の場合' do
        let(:board) { Board.load('./data/solved.txt') }
        it 'trueが返る' do
          expect(board.solved?).to eq true
        end
      end
    end
  end
end