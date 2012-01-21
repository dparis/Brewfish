require 'spec_helper'

describe 'Brewfish' do
  context '::Point' do
    it 'should be successfully initialized with a pair of integer x and y values' do
      point = Brewfish::Point.new( 1, 1 )
      point.should be
    end

    it 'should calculate the raw displacement to another point' do
      start_point = Brewfish::Point.new( 0, 0 )
      end_point = Brewfish::Point.new( 3,4 )

      start_point.displacement_to( end_point ).should == 5.0
    end
    
    it 'should calculate the line to another point' do
      start_point = Brewfish::Point.new( 1, 1 )
      end_point = Brewfish::Point.new( 2, 2 )
      
      start_point.line_to(end_point).should be_an_instance_of(Brewfish::Line)
    end

    context 'class method to build a list of Point instances' do
      it 'should take an array of [x,y] values and return an array of Point instances' do
        built_list = Brewfish::Point.build_list( [1,1], [2,2], [3,3] )

        reference_list = [ Brewfish::Point.new( 1, 1 ),
                           Brewfish::Point.new( 2, 2 ),
                           Brewfish::Point.new( 3, 3 ) ]

        built_list[0].should == reference_list[0]
      end

      it 'should raise an ArgumentError with invalid point arguments' do
        expect { Brewfish::Point.build_list( '1,1', {2 => 2}, 3, 3 ) }.
          to raise_error( ArgumentError, 'points must be passed as an Array of [x,y] Arrays' )
      end
    end
  end

  context '::Line' do
    before(:each) do
      @start_point = Brewfish::Point.new( 1, 1 )
      @end_point = Brewfish::Point.new( 5, 6 )

      @line = Brewfish::Line.new( @start_point, @end_point )

      # A line from (1,1) to (5,6) should include the points
      # (1,1), (2,2), (3,3), (3,4), (4,5), (5,6)
      @points = Brewfish::Point.build_list( [1,1], [2,2], [3,3], [3,4], [4,5], [5,6] )
      @mid_points = Brewfish::Point.build_list( [2,2], [3,3], [3,4], [4,5] )
    end

    context "using Bresenham's line algorithm" do
      it "should calculate all points between the start point and the end point" do
        @line.intermediate_points.should == @mid_points
      end

      it 'should calculate all of the points including the start point and end point' do
        @line.points.should == @points
      end

      it 'should return the length of the path from the start point to the end point' do
        @line.length == (@points.length - 1)
      end
    end
  end
end
