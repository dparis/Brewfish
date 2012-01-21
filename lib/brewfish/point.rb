module Brewfish
  class Point
    #----------------------------------------------------------------------------
    # Attributes
    #----------------------------------------------------------------------------

    attr_reader :x, :y
    
    #----------------------------------------------------------------------------
    # Instance Methods
    #----------------------------------------------------------------------------
    
    def initialize( x, y )
      @x = x
      @y = y
    end

    def ==(other_point)
      self.x == other_point.x && self.y == other_point.y
    end

    def displacement_to(other_point)
      raise ArgumentError unless other_point.class == Brewfish::Point
      Math.hypot( self.x - other_point.x, self.y - other_point.y )
    end

    def line_to(other_point)
      raise ArgumentError unless other_point.class == Brewfish::Point
      Brewfish::Line.new( self, other_point )
    end

    #----------------------------------------------------------------------------
    # Class Methods
    #----------------------------------------------------------------------------
    
    def self.build_list( *raw_points )
      point_list = []

      raw_points.each do |raw_point|
        unless( raw_point.class == Array &&
                raw_point.size == 2 &&
                raw_point.first.class == Fixnum &&
                raw_point.last.class == Fixnum )
          raise ArgumentError, 'points must be passed as an Array of [x,y] Arrays'
        end
        
        point_list.push Point.new( raw_point.first, raw_point.last )
      end

      return point_list
    end
  end
end
