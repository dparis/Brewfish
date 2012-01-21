require 'spec_helper'

describe 'Brewfish' do
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
