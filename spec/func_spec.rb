require 'spec_helper'

describe Func do
  it 'has a version number' do
    expect(Func::VERSION).not_to be nil
  end

  describe '.new_subclass' do
    let(:add) do
      Class.new(Func[:a, :b]) do
        def call
          a + b
        end
      end
    end

    it 'is callable' do
      expect(add[1, 2]).to eq 3
    end

    context 'when there is a block' do
      let(:join_calls) do
        Func[]
        Class.new(Func[:first, :second, '&block']) do
          def call
            [block[first], block[second]].join ' '
          end
        end
      end

      it 'make the block accessible to the call method' do
        expect(join_calls.call('Yay', 'Blocks') { |s| "#{s}!" }).to eq 'Yay! Blocks!'
      end
    end
  end
end
