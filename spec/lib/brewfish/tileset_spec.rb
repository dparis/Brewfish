require 'spec_helper'

describe 'Brewfish' do
  context '::Tileset' do
    before(:each) do
      @gosu_window = Gosu::Window.new( 100, 100, false )
      @tileset = Brewfish::Tileset.new( @gosu_window, :tcod_font_png => :arial_12x12 )
    end

    context 'initializations' do
      it 'should raise an ArgumentError if passed an invalid tileset type' do
        invalid_args = [ :invalid_tileset_type, 'invalid_tileset_type', 1, nil,
                         { :invalid_tileset_type => :invalid } ]

        invalid_args.each do |invalid_arg|
          expect { Brewfish::Tileset.new( @gosu_window, invalid_arg ) }.to raise_error( ArgumentError )
        end
      end

      it 'should load a TCOD font image' do
        tileset = Brewfish::Tileset.new( @gosu_window, :tcod_font_png => :arial_12x12 )
        tile = tileset['X']
        tile.should be_an_instance_of( Gosu::Image )
      end
    end

    it 'should allow a tile lookup by key' do
      tile = @tileset['X']
      tile.should be_an_instance_of( Gosu::Image )
    end

    it 'should allow loading of the tiles after initialization' do
      old_tile = @tileset['X']

      @tileset.load_tiles( :tcod_font_png => :courier_12x12 )
      new_tile = @tileset['X']

      new_tile.should_not == old_tile
    end

    context 'file_name attribute' do
      it 'should exist' do
        @tileset.should respond_to( :file_name )
      end

      it 'should return the file name when the tileset was loaded from a file' do
        @tileset.file_name.should == 'arial12x12.png'
      end
    end

    context 'file_path attribute' do
      it 'should exist' do
        @tileset.should respond_to( :file_path )
      end

      it 'should return the file path when the tileset was loaded from a file' do
        full_font_path = File.join( Brewfish.root, Brewfish::Tileset::DEFAULT_FONT_DIR, 'tcod' )
        @tileset.file_path.should == full_font_path
      end
    end
  end
end
