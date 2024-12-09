defmodule RedNosedReports do
  @doc """
  One report per line
  Numbers in line separated by one space

  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9

  Can only be
   - Gradually increasing
   - Gradually decreasing
   - Diff between adjacent elements betwewen 1 and 3

  """

  @input "2/input.txt"
  @sample "2/input-sample.txt"


  def run() do
    InputReader.get_input_file_stream(@input)
    |> Enum.map(&process_report/1)
    |> Enum.filter(fn {safe?, _monotonicity, _report, _dampener_used} -> safe? end)
    |> Enum.count()
  end

  defp process_report(line) do
    line
    |> String.replace("\n", "")
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce_while({_safe? = false, _monotonicity = nil, _previous_report = nil, _dampener_used = false}, &check_safety/2)
    |> IO.inspect(label: "report [#{line |> String.replace("\n", "")}]")
  end

  defp check_safety(report, {safe?, monotonicity, previous_report, dampener_used}) when is_nil(previous_report), do: {:cont, {safe?, monotonicity, report, dampener_used}}
  defp check_safety(report, {_safe?, monotonicity, previous_report, dampener_used}) do
    case report - previous_report do
      result when result >= 1 and result <= 3 and monotonicity in [:ascending, nil] -> {:cont, {true, :ascending, report, dampener_used}}
      result when result <= -1 and result >= -3 and monotonicity in [:descending, nil] -> {:cont, {true, :descending, report, dampener_used}}
      _ when dampener_used -> {:halt, {false, monotonicity, report, dampener_used}}
      _ when not dampener_used -> {:cont, {true, monotonicity, previous_report, true}}
    end
  end
end
