require 'spec_helper'

require_relative File.join( Brewfish.root, 'lib/brewfish/internal/cell' )

describe 'Brewfish' do
  context '::Internal' do
    # TODO: Define specs for internal classes  --  Fri Jan 27 17:05:00 2012
    context '::Cell' do
      before(:each) do
        @cell = Internal::Cell.new( 0, 0 )
      end

      context 'bg_color method' do
        it 'should mark the cell as dirty when setting color' do
          @cell.dirty = false
          @cell.bg_color = Brewfish::Color.new( :named => :black )
          cell_dirty = @cell.dirty?
          cell_dirty.should == true
        end
      end

      context 'fg_color method' do
        it 'should mark the cell as dirty when setting color' do
          @cell.dirty = false
          @cell.fg_color = Brewfish::Color.new( :named => :black )
          cell_dirty = @cell.dirty?
          cell_dirty.should == true
        end
      end
    end
  end
end
