require 'spec_helper'

describe 'Brewfish' do
  context '::Map' do
    before(:each) do
      @map = Brewfish::Map.new( 100, 100 )
    end

    #----------------------------------------------------------------------------
    # Instance Methods
    #----------------------------------------------------------------------------
    it 'should initialize the map data with a width and height' do
      map = Brewfish::Map.new( 50, 25 )
      map.data.count.should == 25
      map.data.first.count.should == 50
    end

    context 'data method' do
      it { @map.should respond_to( :data ) }
      it { @map.data.should be_an_instance_of( Array ) }
      it { @map.data.first.should be_an_instance_of( Array ) }
      it { @map.data.first.first.should be_an_instance_of( Hash ) }
    end

    context 'width method' do
      it { @map.should respond_to( :width ) }
    end

    context 'height method' do
      it { @map.should respond_to( :height ) }
    end

    context 'get_data_at method' do
      it { @map.should respond_to( :data ) }
      it 'should return the data object indexed at x, y' do
        map = Brewfish::Map.load_from_file( File.join( Brewfish.root, 'spec/resources/maps/test.map' ) )
        data = map.get_data_at( 5, 5 )
        data[:tile_id].should == 'X'
      end      
    end

    context 'save_to_file method' do
      before(:each) do
        @expected_map_filename = File.join( Brewfish.root, 'spec/resources/maps/test.map' )
        @expected_data_filename = File.join( Brewfish.root, 'spec/resources/maps/test.data' )

        @saved_map_filename = File.join( Brewfish.root, 'spec/resources/maps/save_to_file_test.map' )
        @saved_data_filename = File.join( Brewfish.root, 'spec/resources/maps/save_to_file_test.data' )
      end

      it { @map.should respond_to( :save_to_file ) }
      it 'should save the map data to a file correctly' do
        map = Brewfish::Map.load_from_file( @expected_map_filename )
        map.save_to_file( @saved_map_filename )
 
        expected_map_file_contents = nil
        File.open( @expected_map_filename ) do |file|
          expected_map_file_contents = file.read
        end

        expected_data_file_contents = nil
        File.open( @expected_data_filename ) do |file|
          expected_data_file_contents = file.read
        end

        saved_map_file_contents = nil
        File.open( @saved_map_filename ) do |file|
          saved_map_file_contents = file.read
        end

        saved_data_file_contents = nil
        File.open( @saved_data_filename ) do |file|
          saved_data_file_contents = file.read
        end

        saved_map_file_contents.should == expected_map_file_contents
        saved_data_file_contents.should == expected_data_file_contents
      end

      after(:each) do
        File.delete( @saved_map_filename ) if File.exists?( @saved_map_filename )
        File.delete( @saved_data_filename ) if File.exists?( @saved_data_filename )
      end
    end

    #----------------------------------------------------------------------------
    # Class Methods
    #----------------------------------------------------------------------------
    context 'load_from_file class method' do
      it { Brewfish::Map.should respond_to( :load_from_file ) }
      it 'should load a map file from a file' do
        map = Brewfish::Map.load_from_file( File.join( Brewfish.root, 'spec/resources/maps/test.map' ) )
        map.data.count.should == 10
        map.data.first.count.should == 20
        data = map.get_data_at( 5, 5 )
        data[:tile_id].should == 'X'
        data[:test_attribute].should == 'TEST'
      end
    end

  end
end
