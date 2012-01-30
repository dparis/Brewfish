require 'spec_helper'

describe 'Brewfish' do
  context '::Console' do
    before(:each) do
      @console = Brewfish::Console.new
    end

    #----------------------------------------------------------------------------
    # Delegated Accessor Methods
    #----------------------------------------------------------------------------
    context 'cells accessor method' do
      it 'should exist' do
        @console.should respond_to(:cells)
      end

      # TODO: Figure out if there's a way to determine if this is delegated  --  Sat Jan 28 13:13:05 2012
      it 'should be a delegated method'
    end

    context 'tileset accessor method' do
      it 'should exist' do
        @console.should respond_to(:tileset)
      end

      # TODO: Figure out if there's a way to determine if this is delegated  --  Sat Jan 28 13:13:05 2012
      it 'should be a delegated method'
    end

    context 'pixel_width accessor method' do
      it 'should exist' do
        @console.should respond_to(:pixel_width)
      end

      # TODO: Figure out if there's a way to determine if this is delegated  --  Sat Jan 28 13:13:05 2012
      it 'should be a delegated method'
    end

    context 'pixel_height accessor method' do
      it 'should exist' do
        @console.should respond_to(:pixel_height)
      end

      # TODO: Figure out if there's a way to determine if this is delegated  --  Sat Jan 28 13:13:05 2012
      it 'should be a delegated method'
    end

    context 'unit_width accessor method' do
      it 'should exist' do
        @console.should respond_to(:unit_width)
      end

      # TODO: Figure out if there's a way to determine if this is delegated  --  Sat Jan 28 13:13:05 2012
      it 'should be a delegated method'
    end

    context 'unit_height accessor method' do
      it 'should exist' do
        @console.should respond_to(:unit_height)
      end

      # TODO: Figure out if there's a way to determine if this is delegated  --  Sat Jan 28 13:13:05 2012
      it 'should be a delegated method'
    end

    context 'button_down? accessor method' do
      it 'should exist' do
        @console.should respond_to(:button_down?)
      end

      # TODO: Figure out if there's a way to determine if this is delegated  --  Sat Jan 28 13:13:05 2012
      it 'should be a delegated method'
    end

    context 'keyboard_map accessor method' do
      it 'should exist' do
        @console.should respond_to(:keyboard_map)
      end

      # TODO: Figure out if there's a way to determine if this is delegated  --  Sat Jan 28 13:13:05 2012
      it 'should be a delegated method'
    end


    #----------------------------------------------------------------------------
    # Game Methods
    #----------------------------------------------------------------------------
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

    context 'game_close method' do
      it 'should exist' do
        @console.should respond_to(:game_close)
      end
    end

    context 'on_button_down method' do
      it 'should exist' do
        @console.should respond_to(:on_button_down)
      end
    end

    context 'on_button_up method' do
      it 'should exist' do
        @console.should respond_to(:on_button_up)
      end
    end
  end
end
