require 'vanitygen'
require 'bitcoin'

describe Vanitygen do
  let(:pattern_string_a) { '1A' }
  let(:pattern_string_b) { '1B' }
  let(:pattern_any) { '1' }

  describe '.generate' do
    subject { Vanitygen.generate(pattern_string_a) }

    it 'has valid address' do
      expect(subject[:address]).to satisfy { |addr| Bitcoin.valid_address?(addr) }
    end

    it 'has address starting with pattern' do
      expect(subject[:address]).to start_with(pattern_string_a)
    end

    it 'has correct private key to unlock pattern' do
      bkey = Bitcoin::Key.new(subject[:private_key])
      expect(subject[:address]).to eq(bkey.addr)
    end

    it 'matches with case insensitivity' do
      addresses = (1..1000).map { Vanitygen.generate(pattern_string_a, case_insensitive: true)[:address] }
      # Should really be these:
      # expect(addresses).to any(start_with pattern_string_a.upcase)
      # expect(addresses).to any(start_with pattern_string_b.upcase)
      expect(addresses).to satisfy { |a| a.any? { |addr| addr.start_with?(pattern_string_a.upcase) } }
      expect(addresses).to satisfy { |a| a.any? { |addr| addr.start_with?(pattern_string_a.downcase) } }
    end
  end

  describe '.continuous' do
    it 'requires a block' do
      expect{Vanitygen.continuous([pattern_any])}.to raise_error
    end

    context 'with block' do
      it 'runs a lot' do
        yields = []
        Vanitygen.continuous([pattern_any], iters: 10) { |data| yields << data }
        expect(yields.count).to be 10
      end

      it 'returns valid addresses' do
        addresses = []
        Vanitygen.continuous([pattern_any], iters: 4) { |data| addresses << data[:address] }
        expect(addresses).to all(satisfy { |addr| Bitcoin.valid_address?(addr) })
      end

      it 'starts with matching pattern' do
        addresses = []
        Vanitygen.continuous([pattern_string_a], iters: 2) { |data| addresses << data[:address] }
        expect(addresses).to all(start_with(pattern_string_a))
      end
    end
  end

  describe '.difficulty' do
    it 'returns difficulty in Numeric' do
      expect(Vanitygen.difficulty(pattern_string_a)).to be_a Numeric
    end
  end
end
