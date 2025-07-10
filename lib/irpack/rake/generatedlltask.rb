require 'rake'
require 'rake/tasklib'
require 'pathname'
require 'irpack'

module IRPack
  module Rake
  end
end

class IRPack::Rake::GenerateDllTask < ::Rake::TaskLib
  # Task name. default is +exe+.
  attr_accessor :name
  # Spec to generate executable.
  attr_accessor :exe_spec

  # Create tasks that generates exe file.
  # Automatically define the gem if a block is given.
  # If no block is supplied, then +define+
  # needs to be called to define the task.
  def initialize(exe_spec, name=:dll)
    @defined  = false
    @name     = name
    @dll_spec = dll_spec
    if block_given? then
      yield self
      define
    end
  end
  
  # Create rake tasks.
  def define
    raise ArgumentError, "No output_file is specified" unless @dll_spec.output_file
    raise ArgumentError, "No entry_file is specified" unless @dll_spec.entry_file
    output_file = @dll_spec.output_file
    sources = @dll_spec.map_files.values.to_a
    desc "Generate #{File.basename(output_file)}"
    task @name => [output_file]
    file output_file => sources do
      IRPack.pack(@dll_spec)
    end
  end
end
