require 'spec_helper'

describe Func do
  it 'has a version number' do
    expect(Func::VERSION).not_to be nil
  end

  describe 'a direct subclass' do
    let(:block) { proc { |a, b, c| } }
    let(:func) { Func.sig(&block) }

    describe '#arity' do
      it 'should delegate to the block' do
        expect(block).to receive(:arity).and_return 3
        expect(func.arity).to eq 3
      end
    end
  end

  describe 'a "user" subclass' do
    let(:add) do
      Class.new(Func.sig { |a, b| }) do
        def call
          a + b
        end
      end
    end

    it 'is callable' do
      expect(add[1, 2]).to eq 3
    end

    context 'when a block is declared' do
      let(:join_calls) do
        Class.new(Func.sig { |first, second, &block| }) do
          def call
            [block[first], block[second]].join ' '
          end
        end
      end

      it 'makes the block accessible to the call method' do
        expect(join_calls.call('Yay', 'Blocks') { |s| "#{s}!" }).to eq 'Yay! Blocks!'
      end
    end

    context "when it's a variadic Func" do
      let(:func) do
        Class.new(superclass) do
          def call
            [a, b, c]
          end
        end
      end

      context 'with the splat at the beginning' do
        let(:superclass) { Func.sig { |*a, b, c| } }

        it 'should work' do
          expect(func[1, 2, 3, 4]).to eq [[1, 2], 3, 4]
          expect(func[1, 2, 3]).to eq [[1], 2, 3]
          expect(func[1, 2]).to eq [[], 1, 2]
          # expect { func[1] }.to raise_error(ArgumentError)
        end
      end

      context 'with the splat in the middle' do
        let(:superclass) { Func.sig { |a, *b, c| } }

        it 'should work' do
          expect(func[1, 2, 3, 4]).to eq [1, [2, 3], 4]
          expect(func[1, 2, 3]).to eq [1, [2], 3]
          expect(func[1, 2]).to eq [1, [], 2]
          # expect { func[1] }.to raise_error(ArgumentError)
        end
      end

      context 'with the splat at the end' do
        let(:superclass) { Func.sig { |a, b, *c| } }

        it 'should work' do
          expect(func[1, 2, 3, 4]).to eq [1, 2, [3, 4]]
          expect(func[1, 2, 3]).to eq [1, 2, [3]]
          expect(func[1, 2]).to eq [1, 2, []]
          # expect { func[1] }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
