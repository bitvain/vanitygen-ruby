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
      expect{Vanitygen.continuous(pattern_string)}.to raise_error
    end

    context 'with block' do
      let(:yields) { [] }
      subject! do
        Vanitygen.continuous(pattern_any) { |key| yields << key }
      end
      after { subject.kill }

      it { is_expected.to be_instance_of Thread }
      it 'runs a lot' do
        sleep 0.01
        expect(yields.count).to be > 100
      end
    end
  end

  describe '.difficulty' do
    it 'returns difficulty in integer' do
      expect(Vanitygen.difficulty(pattern_string)).to be_a Integer
    end
  end
end
