module Brewfish
  class Map
    #----------------------------------------------------------------------------
    # Attributes
    #----------------------------------------------------------------------------
    attr_reader :data, :width, :height

    #----------------------------------------------------------------------------
    # Instance Methods
    #----------------------------------------------------------------------------
    def initialize( width, height )
      @width, @height = width, height

      @data = []

      height.times do |y_index|
        row = []

        width.times do |x_index|
          row << {}
        end

        @data << row
      end
    end

    def get_data_at( x, y )
      @data[y][x]
    end

    def print_map
      data.each do |row|
        puts row.map{|d| d[:tile_id]}.join
      end
    end

    def save_to_file( file_path )
      # Chop of the extension if one is specified
      match = file_path.match( /^(.*)\.(.*)$/ )
      file_path = match[1] if match
      
      map_file_rows = []
      
      data.each do |row|
        row_string = row.map{|d| d[:tile_id]}.join
        map_file_rows << row_string
      end

      map_file_contents = map_file_rows.join("\n") + "\n"
      File.write( file_path + '.map', map_file_contents )

      File.open( file_path + '.data', 'w' ) do |file|
        data.each do |row|
          row.each{|d| file.write( d.to_yaml )}
        end
      end
    end

    #----------------------------------------------------------------------------
    # Class Methods
    #----------------------------------------------------------------------------
    class << self
      def load_from_file( file_path )
        # Chop of the extension if one is specified
        match = file_path.match( /^(.*)\.(.*)$/ )
        file_path = match[1] if match

        # Load the map file
        map = nil
        
        File.open( file_path + '.map' ) do |file|
          width  = file.gets.chomp.length
          file.rewind

          file_rows = []
          
          file.each do |line|
            chars = line.chomp.split( '' )
            chars = chars.fill( ' ', chars.length, width - chars.length )
            file_rows << chars
          end

          height = file_rows.count

          map = Brewfish::Map.new( width, height )
          map.data.each_index do |y_index|
            map.data[y_index].each_index do |x_index|
              data = map.data[y_index][x_index]
              data[:tile_id] = file_rows[y_index][x_index]
              data[:x] = x_index
              data[:y] = y_index
            end
          end
        end

        # Load the associated data file if it exists
        if File.exists?( file_path + '.data' )
          File.open( file_path + '.data' ) do |file|
            YAML.load_documents( file ) do |object|
              x, y = object[:x], object[:y]
              map.data[y][x].merge!( object )
            end
          end
        end
        
        return map
      end
    end
  end
end
