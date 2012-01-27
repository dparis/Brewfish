require 'spec_helper'

describe 'Brewfish' do
  context '::Console' do
    before(:each) do
      @console = Brewfish::Console.new
    end

    context 'update method' do
      it 'should exist'
      it 'should accept a block'
      it 'should affect the state of the cells'
    end

    context 'show method' do
      it 'should exist'
    end

    context '::Internal' do
      context '::GosuConsole' do
      end
    end
  end
end
