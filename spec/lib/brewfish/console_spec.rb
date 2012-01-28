require 'spec_helper'

describe 'Brewfish' do
  context '::Console' do
    before(:each) do
      @console = Brewfish::Console.new
    end

    # TODO: Flesh these out more  --  Fri Jan 27 17:04:05 2012
    context 'game_setup method' do
      it 'should exist' do
        @console.should respond_to(:game_setup)
      end
    end

    context 'game_loop method' do
      it 'should exist' do
        @console.should respond_to(:game_loop)
      end
    end

    context 'game_start method' do
      it 'should exist' do
        @console.should respond_to(:game_start)
      end
    end
  end
end
