require 'spec_helper'

describe Func do
  describe 'a subclass with kwargs' do
    let(:add) do
      Class.new(Func) do
        def initialize(a: 1, b: 2) super end

        def call
          @a + @b
        end
      end
    end

    it 'is callable' do
      expect(add.(a: 3, b: 4)).to eq 7
      expect(add.(a: 3)).to eq 5
      expect(add.(b: 3)).to eq 4
      expect(add.()).to eq 3
    end
  end
end
