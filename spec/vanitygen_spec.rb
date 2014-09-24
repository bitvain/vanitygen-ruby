require 'vanitygen'

describe Vanitygen do
  describe '.generate' do
    describe 'with string argument' do
      subject { Vanitygen.generate('1ab') }
      it { is_expected.to start_with(string_pattern) }
    end
  end
end
