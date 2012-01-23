require 'spec_helper'

describe 'Brewfish' do
  context '::Color' do
    before(:each) do
      @black = Brewfish::Color.new( :named => :black )
      @white = Brewfish::Color.new( :named => :white )

      @light_red = Brewfish::Color.new( :named => :light_red )
      @red = Brewfish::Color.new( :named => :red )
      @dark_red = Brewfish::Color.new( :named => :dark_red )

      @dark_grey = Brewfish::Color.new( :named => :dark_grey )
      
      @ref_color = Brewfish::Color.new( :rgba => [0xAA, 0xBB, 0xCC, 0xFF] )
      @ref_color_int = 0xFFAABBCC
      @ref_red   = 0xAA
      @ref_green = 0xBB
      @ref_blue  = 0xCC
      @ref_alpha = 0xFF
      @ref_hue   = 210.0
      @ref_sat   = 0.16666666666666677
      @ref_value = 0.8
    end

    context 'initializations' do
      it 'should should raise an ArgumentError if initialized improperly' do
        [ 1, -2, [1,2], { :rgb => [] }, { :rgb => [1,2] }, {:rgba => [1,2,3]},
          {:hsv => [1,2]}, {:hsva => [1,2]} ].each do |bad_arg|
          expect { Brewfish::Color.new(bad_arg) }.to raise_error( ArgumentError )
        end
      end

      it 'should initialize with no arguments as RGBA [0,0,0,255]' do
        color = Brewfish::Color.new

        color.red.should   == 0
        color.green.should == 0
        color.blue.should  == 0
        color.alpha.should == 255
      end
      
      it 'should accept 32-bit packed ARGB value' do
        color = Brewfish::Color.new( :argb_int => @ref_color_int )

        color.red.should   == @ref_red
        color.green.should == @ref_green
        color.blue.should  == @ref_blue
        color.alpha.should == @ref_alpha
      end

      it 'should accept array of RGBA 8-bit values' do
        color = Brewfish::Color.new( :rgba => [ @ref_red, @ref_green, @ref_blue, @ref_alpha ] )
        color.should == @ref_color
      end

      it 'should accept array of RGB 8-bit values' do
        color = Brewfish::Color.new( :rgb => [ @ref_red, @ref_green, @ref_blue ] )
        color.should == @ref_color
      end
      
      it 'should accept array of HSVA values' do
        color = Brewfish::Color.new( :hsva => [ @ref_hue, @ref_sat, @ref_value, @ref_alpha ] )
        color.should == @ref_color
      end

      it 'should accept array of HSV values' do
        color = Brewfish::Color.new( :hsv => [ @ref_hue, @ref_sat, @ref_value ] )
        color.should == @ref_color
      end
      
      it 'should accept a named color' do
        color = Brewfish::Color.new( :named => :ref_color )
        color.should == @ref_color
      end
    end

    context 'binary operations' do
      it 'should calculate the product of two colors' do
        @res = ( @dark_grey * @light_red )
        @res.should == Brewfish::Color.new( :rgb => [95, 23, 23] )
      end

      it 'should calculate the product of a color and a number' do
        @res = ( @light_red * 0.5 )
        @res.should == Brewfish::Color.new( :rgb => [127, 31, 31] )
      end

      it 'should calculate the sum of two colors' do
        @res = ( @light_red + @dark_grey )
        @res.should == Brewfish::Color.new( :rgb => [255, 158, 158] )
      end

      it 'should calculate the difference of two colors' do
        @res = ( @light_red - @dark_grey )
        @res.should == Brewfish::Color.new( :rgb => [160, 0, 0] )
      end
    end

    it 'should calculate the linear interpolant between two colors and return a color on that gradient based on a given coefficient' do
      @light_red.lerp( @dark_grey, 0.5 ).should == Brewfish::Color.new( :rgb => [175, 79, 79] )
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
