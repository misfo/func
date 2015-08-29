require 'spec_helper'

describe Func do
  it 'has a version number' do
    expect(Func::VERSION).not_to be nil
  end

  describe '.new_subclass' do
    it 'raises an error when given multiple splats' do
      error = Func::Signature::MultipleSplatsError
      expect { Func[:a, '*b', '*c'] }.to raise_error(error)
      expect { Func['*a', :b, '*c'] }.to raise_error(error)
    end

    it "raises an error when the block isn't last" do
      error = Func::Signature::InvalidBlockPositionError
      expect { Func['&a', :b] }.to raise_error(error)
      expect { Func[:a, '&b', :c] }.to raise_error(error)
    end
  end

  describe 'a "user" subclass' do
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

    context 'when a block is declared' do
      let(:join_calls) do
        Func[]
        Class.new(Func[:first, :second, '&block']) do
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
        let(:superclass) { Func['*a', :b, :c] }

        it 'should work' do
          expect(func[1, 2, 3, 4]).to eq [[1, 2], 3, 4]
          expect(func[1, 2, 3]).to eq [[1], 2, 3]
          expect(func[1, 2]).to eq [[], 1, 2]
          # expect { func[1] }.to raise_error(ArgumentError)
        end
      end

      context 'with the splat in the middle' do
        let(:superclass) { Func[:a, '*b', :c] }

        it 'should work' do
          expect(func[1, 2, 3, 4]).to eq [1, [2, 3], 4]
          expect(func[1, 2, 3]).to eq [1, [2], 3]
          expect(func[1, 2]).to eq [1, [], 2]
          # expect { func[1] }.to raise_error(ArgumentError)
        end
      end

      context 'with the splat at the end' do
        let(:superclass) { Func[:a, :b, '*c'] }

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
