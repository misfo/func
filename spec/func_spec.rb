require 'spec_helper'

describe Func do
  it 'has a version number' do
    expect(Func::VERSION).not_to be nil
  end

  describe 'a subclass' do
    let(:add) do
      Class.new(Func) do
        def initialize(a, b) super end

        def call
          @a + @b
        end
      end
    end

    it 'is callable' do
      expect(add[1, 2]).to eq 3
    end

    context 'when a block is declared' do
      let(:join_calls) do
        Class.new(Func) do
          def initialize(first, second, &block) super end

          def call
            [@block.(@first), @block.(@second)].join ' '
          end
        end
      end

      it 'makes the block accessible to the call method' do
        expect(join_calls.('Yay', 'Blocks') { |s| "#{s}!" }).to eq 'Yay! Blocks!'
      end
    end

    context "when it's a variadic Func" do
      let(:func) do
        Class.new(Func) do
          def call
            [@a, @b, @c]
          end
        end
      end

      before { func.class_exec(&init) }

      context 'with the splat at the beginning' do
        let(:init) { proc { def initialize(*a, b, c) super end } }

        it 'should work' do
          expect(func[1, 2, 3, 4]).to eq [[1, 2], 3, 4]
          expect(func[1, 2, 3]).to eq [[1], 2, 3]
          expect(func[1, 2]).to eq [[], 1, 2]
          expect { func[1] }.to raise_error(ArgumentError)
        end
      end

      context 'with the splat in the middle' do
        let(:init) { proc { def initialize(a, *b, c) super end } }

        it 'should work' do
          expect(func[1, 2, 3, 4]).to eq [1, [2, 3], 4]
          expect(func[1, 2, 3]).to eq [1, [2], 3]
          expect(func[1, 2]).to eq [1, [], 2]
          expect { func[1] }.to raise_error(ArgumentError)
        end
      end

      context 'with the splat at the end' do
        let(:init) { proc { def initialize(a, b, *c) super end } }

        it 'should work' do
          expect(func[1, 2, 3, 4]).to eq [1, 2, [3, 4]]
          expect(func[1, 2, 3]).to eq [1, 2, [3]]
          expect(func[1, 2]).to eq [1, 2, []]
          expect { func[1] }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
