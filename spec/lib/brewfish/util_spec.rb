describe 'Brewfish' do
  context '::Util' do
    context '::Math' do
      context 'clamp method' do
        it 'should restrict number larger than the range max to the max value of the range' do
          range = (1..10)
          large_number = 9999

          Brewfish::Util::Math.clamp( large_number, range ).should == range.max
        end

        it 'should restrict number smaller than the range min to the min value of the range' do
          range = (100..999)
          small_number = 1

          Brewfish::Util::Math.clamp( small_number, range ).should == range.min
        end

        it 'should return the number if it falls within the range' do
          range = (1..100)
          number_in_range = 50
          
          Brewfish::Util::Math.clamp( number_in_range, range ).should == number_in_range
        end
      end
    end
  end
end
