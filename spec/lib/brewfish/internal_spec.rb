require 'spec_helper'
require 'pry'

require_relative File.join( Brewfish.root, 'lib/brewfish/internal/cell' )

describe 'Brewfish' do
  context '::Internal' do
    context '::Cell' do
      before(:each) do
        console = double(:width => 200, :height => 200)
        Internal::Cell.configure_dimensions( console )
        Internal::Cell.drawn_all
        
        @cell = Internal::Cell.new( 10, 20 )
      end

      #----------------------------------------------------------------------------
      # Class Methods
      #----------------------------------------------------------------------------
      context 'configure_dimensions class method' do
        context 'based on the console object passed' do
          before(:each) do
            console = double(:width => 400, :height => 400)
            Internal::Cell.configure_dimensions( console )
          end

          it 'should set the unit width of the cell grid' do
            unit_width = Internal::Cell.class_variable_get :@@unit_width
            unit_width.should == 400
          end

          it 'should set the unit height of the cell grid' do
            unit_height = Internal::Cell.class_variable_get :@@unit_height
            unit_height.should == 400
          end
        end
      end

      context 'any_dirty? class method' do
        before(:each) do
          Internal::Cell.drawn_all
        end

        it 'should indicate if any Cell object is dirty' do
          @cell.dirty = true
          any_dirty = Internal::Cell.any_dirty?
          any_dirty.should == true
        end
      end

      context 'drawn_all method' do
        before(:each) do
          @cell.dirty = true
        end

        it 'should reset the any_dirty? flag when called' do
          Internal::Cell.drawn_all
          any_dirty = Internal::Cell.any_dirty?
          any_dirty.should == false
        end
      end

      #----------------------------------------------------------------------------
      # Instance Methods
      #----------------------------------------------------------------------------
      context 'x method' do
        it { @cell.should respond_to( :x ) }
        it 'should return the horizontal unit position of the cell in the console grid' do
          @cell.x.should == 10
        end
      end

      context 'y method' do
        it { @cell.should respond_to( :y ) }
        it 'should return the vertical unit position of the cell in the console grid' do
          @cell.y.should == 20
        end
      end

      context 'tile method' do
        it { @cell.should respond_to( :tile ) }
        it 'should mark the cell as dirty when setting the tile' do
          @cell.dirty = false
          @cell.tile = double("tile")
          cell_dirty = @cell.dirty?
          cell_dirty.should == true
        end
      end

      context 'char method' do
        it { @cell.should respond_to( :char ) }
        it 'should mark the cell as dirty when setting the char' do
          @cell.dirty = false
          @cell.tile = double("char")
          cell_dirty = @cell.dirty?
          cell_dirty.should == true
        end
      end

      context 'bg_argb method' do
        it { @cell.should respond_to( :bg_argb ) }
        it 'should mark the cell as dirty when setting color' do
          @cell.dirty = false
          @cell.bg_argb = Brewfish::Color.new( :named => :black ).argb
          cell_dirty = @cell.dirty?
          cell_dirty.should == true
        end
      end

      context 'fg_argb method' do
        it { @cell.should respond_to( :fg_argb ) }
        it 'should mark the cell as dirty when setting color' do
          @cell.dirty = false
          @cell.fg_argb = Brewfish::Color.new( :named => :black ).argb
          cell_dirty = @cell.dirty?
          cell_dirty.should == true
        end
      end

      context 'dirty setter method' do
        it { @cell.should respond_to( :dirty= ) }
        it 'should notify the class that a cell is dirty' do
          @cell.dirty = true
          any_dirty = Internal::Cell.any_dirty?
          any_dirty.should == true
        end
      end
        
      context 'dirty? getter method' do
        it { @cell.should respond_to( :dirty? ) }
      end

      context 'draw method' do
        it { @cell.should respond_to( :draw ) }
      end

      context 'clear method' do
        before(:each) do
          @cell.tile = double('tile')
          @cell.char = double('char')
          @cell.bg_argb = double('bg_argb')
          @cell.fg_argb = double('fg_argb')
        end

        it { @cell.should respond_to( :clear ) }

        it 'should reset tile' do
          @cell.clear
          @cell.tile.should be_nil
        end
        
        it 'should reset char' do
          @cell.clear
          @cell.char.should be_nil
        end

        it 'should reset bg_argb' do
          @cell.clear
          @cell.bg_argb.should be_nil
        end

        it 'should reset fg_argb' do
          @cell.clear
          @cell.fg_argb.should be_nil
        end
      end
    end

    ###############################################################################

    context '::GosuCell' do
      before(:each) do
        console = Brewfish::Console.new( :type => :gosu, :pixel_width => 240, :pixel_height => 240 )
        Internal::GosuCell.configure_dimensions( console )
        
        @cell = Internal::GosuCell.new( 2, 4 )
      end

      #----------------------------------------------------------------------------
      # Class Methods
      #----------------------------------------------------------------------------
      context 'configure_dimensions class method' do
        context 'based on the console object passed' do
          before(:each) do
            # Set the dimensions so that there's a bit of unusable
            # space at the bottom and right margins in order to test
            # that it handles clipping the cells properly
            console = Brewfish::Console.new( :type => :gosu, :pixel_width => 250, :pixel_height => 250,
                                             :tileset => { :tcod_font_png => :arial_12x12 } )
            Internal::GosuCell.configure_dimensions( console )
          end

          it 'should set the unit width of the cell grid' do
            unit_width = Internal::GosuCell.class_variable_get :@@unit_width
            unit_width.should == 20
          end

          it 'should set the unit height of the cell grid' do
            unit_height = Internal::GosuCell.class_variable_get :@@unit_height
            unit_height.should == 20
          end

          it 'should set the maximum horizontal pixel position' do
            max_pixel_x = Internal::GosuCell.class_variable_get :@@max_pixel_x
            max_pixel_x.should == 240
          end            

          it 'should set the maximum vertical pixel position' do
            max_pixel_y = Internal::GosuCell.class_variable_get :@@max_pixel_y
            max_pixel_y.should == 240
          end            
        end
      end
      
      #----------------------------------------------------------------------------
      # Instance Methods
      #----------------------------------------------------------------------------
      context 'pixel_x method' do
        it { @cell.should respond_to( :pixel_x ) }
        it 'should return the horizontal pixel position of the cell in the console window' do
          @cell.pixel_x.should == 24
        end
      end

      context 'pixel_y method' do
        it { @cell.should respond_to( :pixel_y ) }
        it 'should return the vertical pixel position of the cell in the console window' do
          @cell.pixel_y.should == 48
        end
      end

      context 'calculate_x_y private method' do
        it 'should be called from the initialize method' do
          cell = Internal::GosuCell.new( 2, 4 )
          
          x1, y1 = cell.instance_variable_get( :@quad_x1 )
          x1.should_not be_nil
        end

        it 'should set up the quad coordinates correctly' do
          cell = Internal::GosuCell.new( 2, 4 )
          
          x1, y1 = cell.instance_variable_get( :@quad_x1 ), cell.instance_variable_get( :@quad_y1 )
          x2, y2 = cell.instance_variable_get( :@quad_x2 ), cell.instance_variable_get( :@quad_y2 )
          x3, y3 = cell.instance_variable_get( :@quad_x3 ), cell.instance_variable_get( :@quad_y3 )
          x4, y4 = cell.instance_variable_get( :@quad_x4 ), cell.instance_variable_get( :@quad_y4 )

          x1.should == 24
          y1.should == 48

          x2.should == 35
          y2.should == 48

          x3.should == 24
          y3.should == 59

          x4.should == 35
          y4.should == 59
        end
      end
    end
  end
end
