defmodule InputReader do

  @base_path File.cwd! <> "/inputs/"

  def get_input_file_stream(path) do
    File.stream!(@base_path <> path, read_ahead: 1)
  end

end
