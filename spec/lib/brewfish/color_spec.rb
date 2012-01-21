require 'spec_helper'

describe 'Brewfish' do
  context '::Color' do
    before(:each) do
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
  end
end
