module Brewfish
  class Line
    #----------------------------------------------------------------------------
    # Attributes
    #----------------------------------------------------------------------------

    attr_reader :start_point, :intermediate_points
    attr_accessor :end_point

    #----------------------------------------------------------------------------
    # Instance Methods
    #----------------------------------------------------------------------------
    
    def initialize( start_point, end_point )
      @start_point = start_point
      @end_point = end_point
      
      calculate_line
    end

    # Return all points for the line, including the start and end points
    def points
      [start_point, intermediate_points, end_point].flatten
    end

    # Calculate the length of the path described by the line, which
    # should be the number of points in the line past the start point
    def length
      points.length - 1
    end

    #----------------------------------------------------------------------------
    # Private methods
    #----------------------------------------------------------------------------
    
    private

    # Perform Bresenham's line algorithm and store all of the
    # intermediate points in the points attribute
    # NOTE: http://en.wikipedia.org/wiki/Bresenham's_line_algorithm
    def calculate_line
      # Get the from/to x/y values
      from_x = @start_point.x
      from_y = @start_point.y

      to_x = @end_point.x
      to_y = @end_point.y

      # Calculate the magnitude of the delta x/y values
      dx = (to_x - from_x).abs
      dy = (to_y - from_y).abs

      # Determine the step direction for x/y
      step_x = (from_x < to_x) ? 1 : -1
      step_y = (from_y < to_y) ? 1 : -1

      # Error is considered along both axes simultaneously
      error = dx-dy

      # Calculate each step of the line and store as a point in the
      # points attribute
      @intermediate_points = []

      cur_x = from_x
      cur_y = from_y

      while true
        # Stash the point
        @intermediate_points.push Brewfish::Point.new( cur_x, cur_y )

        # The end of the line has been reached, so break
        break if cur_x == to_x && cur_y == to_y

        double_error = error * 2

        if double_error > -dy
          error = error - dy
          cur_x = cur_x + step_x
        end

        if double_error < dx
          error = error + dx
          cur_y = cur_y + step_y
        end        
      end

      # Remove the first and last points from the array since the
      # start_point and end_point should not be included
      @intermediate_points.shift
      @intermediate_points.pop
    end
  end
end
