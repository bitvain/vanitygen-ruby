require 'vanitygen'
require 'bitcoin'

describe Vanitygen do
  let(:pattern_string_a) { '1A' }
  let(:pattern_string_b) { '1B' }
  let(:pattern_regex_foo) { /[fF][oO][oO]/ }
  let(:pattern_any) { '1' }

  describe '.generate' do
    context 'string' do
      subject { Vanitygen.generate(pattern_string_a) }

      it 'has valid address' do
        expect(subject[:address]).to satisfy { |addr| Bitcoin.valid_address?(addr) }
      end

      it 'has address starting with pattern' do
        expect(subject[:address]).to start_with(pattern_string_a)
      end

      it 'has correct wif (wallet import format) to unlock pattern' do
        bkey = Bitcoin::Key.from_base58(subject[:wif])
        expect(subject[:address]).to eq(bkey.addr)
      end

      it 'matches with case insensitivity' do
        addresses = (1..300).map { Vanitygen.generate(pattern_string_a, case_insensitive: true)[:address] }
        # Should really be these:
        # expect(addresses).to any(start_with pattern_string_a.upcase)
        # expect(addresses).to any(start_with pattern_string_b.upcase)
        expect(addresses).to satisfy { |a| a.any? { |addr| addr.start_with?(pattern_string_a.upcase) } }
        expect(addresses).to satisfy { |a| a.any? { |addr| addr.start_with?(pattern_string_a.downcase) } }
      end
    end

    context 'regex' do
      subject { Vanitygen.generate(pattern_regex_foo) }

      it 'has valid address' do
        expect(subject[:address]).to satisfy { |addr| Bitcoin.valid_address?(addr) }
      end

      it 'has address matching pattern' do
        expect(subject[:address]).to match(pattern_regex_foo)
      end
    end
  end

  describe '.continuous' do
    it 'requires a block' do
      expect{Vanitygen.continuous([pattern_any])}.to raise_error(LocalJumpError)
    end

    context 'with block' do
      let(:noop) { proc{} }
      let(:captured) { [] }

      def capture(attr=nil)
        if attr
          proc { |data| captured << data[:address] }
        else
          proc { |data| captured << data }
        end
      end

      it 'runs a lot' do
        Vanitygen.continuous([pattern_any], iters: 10, &capture)
        expect(captured.count).to be 10
      end

      it 'returns valid addresses' do
        Vanitygen.continuous([pattern_any], iters: 4, &capture(:address))
        expect(captured).to all(satisfy { |addr| Bitcoin.valid_address?(addr) })
      end

      it 'starts with matching pattern' do
        Vanitygen.continuous([pattern_string_a], iters: 2, &capture(:address))
        expect(captured).to all(start_with(pattern_string_a))
      end

      it 'supports regexes' do
        Vanitygen.continuous([pattern_regex_foo], iters: 1, &capture(:address))
        expect(captured).to all(match(pattern_regex_foo))
      end

      it 'dies if using mixed types' do
        expect{Vanitygen.continuous([pattern_regex_foo, pattern_string_a], &noop)}.to raise_error(TypeError)
      end
    end
  end

  describe '.difficulty' do
    it 'returns difficulty in Numeric' do
      expect(Vanitygen.difficulty(pattern_string_a)).to be_a Numeric
    end
  end
end
