require 'spec_helper'

require 'vanitygen'
require 'bitcoin'

describe Vanitygen do
  let(:pattern_string_a)  { '1A' }
  let(:pattern_string_b)  { '1B' }
  let(:pattern_string_ab) { '1AB' }
  let(:pattern_regex_ab)  { /[aA][bB]/ }
  let(:pattern_any)       { '1' }

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

      xit 'uses threads' do
        #Buggy threading!
        single = timeit { Vanitygen.generate(pattern_string_ab) }
        multi = timeit { Vanitygen.generate(pattern_string_ab, threads: 8) }
        expect(multi).to be < single
      end
    end

    context 'regex' do
      subject { Vanitygen.generate(pattern_regex_ab) }

      it 'has valid address' do
        expect(subject[:address]).to satisfy { |addr| Bitcoin.valid_address?(addr) }
      end

      it 'has address matching pattern' do
        expect(subject[:address]).to match(pattern_regex_ab)
      end
    end
  end

  describe '.continuous' do
    it 'requires a block' do
      expect{Vanitygen.continuous([pattern_any])}.to raise_error(LocalJumpError)
    end

    it 'requires same type' do
      noop = proc{}
      expect{Vanitygen.continuous([pattern_regex_ab, pattern_string_a], &noop)}.to raise_error(TypeError)
    end

    context 'threaded with capture block' do
      let(:captured) { [] }

      after do
        Thread.list.each do |thread|
          thread.kill unless thread == Thread.current
        end
      end

      def capture(attr=nil)
        if attr.nil?
          proc { |data| captured << data }
        else
          proc { |data| captured << data[attr] }
        end
      end

      def threaded_continuous(*args, &block)
        Thread.new do
          Vanitygen.continuous(*args, &block)
        end
      end

      context 'base test' do
        before do
          threaded_continuous([pattern_any], &capture(:address))
        end

        it 'runs a lot' do
          sleep 0.1
          expect(captured.count).to be > 10
        end

        it 'returns valid addresses' do
          sleep 0.1
          expect(captured).to all(satisfy { |addr| Bitcoin.valid_address?(addr) })
        end
      end

      context 'with string' do
        it 'starts with matching pattern' do
          threaded_continuous([pattern_string_a], &capture(:address))
          sleep 0.1
          expect(captured.size).to be > 1
          expect(captured).to all(start_with(pattern_string_a))
        end

        it 'matches with case insensitivity' do
          threaded_continuous([pattern_string_ab], case_insensitive: true, &capture(:address))
          sleep 0.2
          prefixes = captured.map { |addr| addr[0..2] }
          expect(prefixes.uniq.size).to be > 1
        end
      end

      context 'with regex' do
        it 'matches the regex' do
          threaded_continuous([pattern_regex_ab], &capture(:address))
          sleep 0.1
          expect(captured.size).to be > 1
          expect(captured).to all(match(pattern_regex_ab))
        end
      end
    end
  end

  describe '.difficulty' do
    it 'returns difficulty in Numeric' do
      expect(Vanitygen.difficulty(pattern_string_a)).to be_a Numeric
    end
  end

  describe '.valid?' do
    it 'is true for starting with 1' do
      expect(Vanitygen.valid?('1abc')).to be(true)
    end

    it 'is false for starting with something else' do
      expect(Vanitygen.valid?('abc')).to be(false)
    end

    it 'is false for really long strings' do
      expect(Vanitygen.valid?('1abcdefghijklmnopqrstuvwxyz')).to be(false)
    end

    it 'is false for illegal characters' do
      expect(Vanitygen.valid?('10')).to be(false)
      expect(Vanitygen.valid?('1O')).to be(false)
      expect(Vanitygen.valid?('1I')).to be(false)
      expect(Vanitygen.valid?('1l')).to be(false)
    end
  end
end
