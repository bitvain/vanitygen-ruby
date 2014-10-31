require 'vanitygen'
require 'bitcoin'

describe Vanitygen do
  let(:pattern_string_a) { '1A' }
  let(:pattern_string_b) { '1B' }
  let(:pattern_any) { '1' }

  describe '.generate' do
    context 'with string argument' do
      subject { Vanitygen.generate(pattern_string_a) }

      it 'has valid address' do
        expect(subject[:address]).to satisfy { |addr| Bitcoin.valid_address?(addr) }
      end

      it 'has address starting with pattern' do
        expect(subject[:address]).to start_with(pattern_string_a)
      end

      it 'has correct private key to unlock pattern' do
        bkey = Bitcoin::Key.new(subject[:priv_key])
        expect(subject[:address]).to eq(bkey.addr)
      end
    end

    context 'with many string arguments' do
      it 'can be either 1A or 1B' do
        10.times do
          data = Vanitygen.generate(pattern_string_a, pattern_string_b)
          expect(data[:address]).to start_with(pattern_string_a) | start_with(pattern_string_b)
        end
      end
    end
  end

  describe '.continuous' do
    it 'requires a block' do
      expect{Vanitygen.continuous(pattern_any)}.to raise_error
    end

    context 'with block' do
      it 'runs a lot' do
        yields = []
        Vanitygen.continuous(pattern_any, iters: 10) { |data| yields << data }
        expect(yields.count).to be 10
      end

      it 'returns valid addresses' do
        yields = []
        Vanitygen.continuous(pattern_any, iters: 4) { |data| yields << data }
        expect(yields).to all(satisfy { |data| Bitcoin.valid_address?(data[:address]) })
      end

      it 'starts with matching pattern' do
        yields = []
        Vanitygen.continuous(pattern_string_a, iters: 2) { |data| yields << data }
        expect(yields).to all(satisfy { |data| data[:address].start_with?(pattern_string_a)} )
      end
    end
  end

  describe '.difficulty' do
    it 'returns difficulty in integer' do
      expect(Vanitygen.difficulty(pattern_string_a)).to be_a Integer
    end
  end
end
