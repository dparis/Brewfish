require 'brewfish/console'
require 'brewfish/tileset'
require 'brewfish/point'
require 'brewfish/line'
require 'brewfish/color'
require 'brewfish/util'

require 'brewfish/version'

module Brewfish
  def self.root
    @root ="#{File.expand_path('../..',__FILE__)}"
  end
end
