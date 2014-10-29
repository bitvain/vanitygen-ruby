require 'vanitygen'

describe Vanitygen do
  let(:pattern_string) { '1ab' }
  let(:pattern_any) { '1' }

  describe '.generate' do
    context 'with string argument' do
      subject { Vanitygen.generate(pattern_string) }
      it { is_expected.to start_with(pattern_string) }
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

      it 'matches' do
        yields = []
        Vanitygen.continuous(pattern_string, iters: 2) { |key| yields << key }
        expect(yields).to all(start_with(pattern_string))
      end
    end
  end

  describe '.difficulty' do
    it 'returns difficulty in integer' do
      expect(Vanitygen.difficulty(pattern_string)).to be_a Integer
    end
  end
end
