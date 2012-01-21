require 'spec_helper'

describe 'Brewfish' do
  context '::Color' do
    before(:each) do
      @black = Brewfish::Color.new( :named => :black )
      @white = Brewfish::Color.new( :named => :white )

      @red = Brewfish::Color.new( :named => :red )
      @green = Brewfish::Color.new( :named => :green )
      @blue = Brewfish::Color.new( :named => :blue )

      @dark_grey = Brewfish::Color.new( :named => :dark_grey )
      @light_red = Brewfish::Color.new( :named => :light_red )
      @dark_red = Brewfish::Color.new( :named => :dark_red )
    end

    context 'initialized as HSV' do
      it 'should convert across HSV->HSL->RGB properly' do
        rgb_color = Brewfish::Color.new( :hsv => [ 0, 0.753, 1.0 ] )
        rgb_color.should == @light_red
      end
    end
    
    context 'initialzed as named color' do
      it 'should raise an ArgumentError if the named color cannot be found' do
        expect { Brewfish::Color.new( :named => :invalid_color_name ) }.
          to raise_error ArgumentError
      end
    end

    context 'binary operations' do
      it 'should calculate the product of two colors' do
        ( @dark_grey * @light_red ).should == Brewfish::Color.new( :rgb => [95, 23, 23] )
      end

      it 'should calculate the product of a color and a number' do
        ( @light_red * 0.5 ).should == Brewfish::Color.new( :rgb => [127, 31, 31] )
      end

      it 'should calculate the sum of two colors' do
        ( @light_red + @dark_grey ).should == Brewfish::Color.new( :rgb => [255, 158, 158] )
      end

      it 'should calculate the different of two colors' do
        ( @light_red - @dark_grey ).should == Brewfish::Color.new( :rgb => [160, 0, 0] )
      end
    end

    it 'should calculate the linear interpolant between two colors and return a color on that gradient based on a given coefficient' do
      @light_red.lerp( @dark_grey, 0.5 ).should == Brewfish::Color.new( :rgb => [175, 79, 79] )
    end

    it 'should return correct hsv values' do
      @red.hsv_values.should == [0, 1, 1]
    end

    it 'should return correct hsl values' do
      @red.hsl_values.should == [0, 1, 0.5]
    end

    it 'should produce a color map given a hash of key colors and indices' do
      key_colors = [ [0, @black], [4, @red], [8, @white] ]

      expected_color_map = {
        0 => Brewfish::Color.new( :rgb => [ 0, 0, 0 ] ),
        1 => Brewfish::Color.new( :rgb => [ 63, 0, 0 ] ),
        2 => Brewfish::Color.new( :rgb => [ 127, 0, 0 ] ),
        3 => Brewfish::Color.new( :rgb => [ 191, 0, 0 ] ),
        4 => Brewfish::Color.new( :rgb => [ 255, 0, 0 ] ),
        5 => Brewfish::Color.new( :rgb => [ 255, 63, 63 ] ),
        6 => Brewfish::Color.new( :rgb => [ 255, 127, 127 ] ),
        7 => Brewfish::Color.new( :rgb => [ 255, 191, 191 ] ),
        8 => Brewfish::Color.new( :rgb => [ 255, 255, 255 ] )
      }

      color_map = Brewfish::Color.build_color_map( key_colors )

      color_map.should == expected_color_map
    end
  end
end
