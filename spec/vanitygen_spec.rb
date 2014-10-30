require 'vanitygen'
require 'bitcoin'

describe Vanitygen do
  let(:pattern_string) { '1A' }
  let(:pattern_any) { '1' }

  describe '.generate' do
    context 'with string argument' do
      subject { Vanitygen.generate(pattern_string) }

      it 'has valid address' do
        expect(subject.addr).to satisfy { |addr| Bitcoin.valid_address?(addr) }
      end

      it 'has address starting with pattern' do
        expect(subject.addr).to start_with(pattern_string)
      end

      it 'has correct private key to unlock pattern' do
        bkey = Bitcoin::Key.new(subject.priv)
        expect(subject.addr).to eq(bkey.addr)
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
        Vanitygen.continuous(pattern_any, iters: 10) { |key| yields << key }
        expect(yields.count).to be 10
      end

      it 'returns valid addresses' do
        yields = []
        Vanitygen.continuous(pattern_any, iters: 4) { |key| yields << key }
        expect(yields).to all(satisfy { |key| Bitcoin.valid_address?(key.addr) })
      end

      it 'starts with matching pattern' do
        yields = []
        Vanitygen.continuous(pattern_string, iters: 2) { |key| yields << key }
        expect(yields).to all(satisfy { |key| key.addr.start_with?(pattern_string)} )
      end
    end
  end

  describe '.difficulty' do
    it 'returns difficulty in integer' do
      expect(Vanitygen.difficulty(pattern_string)).to be_a Integer
    end
  end
end
