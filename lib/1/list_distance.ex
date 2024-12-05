defmodule ListDistance do

  def run() do
    input_file_path = File.cwd! <> "/inputs/1/input.txt"

    prepared_lists =
      File.stream!(input_file_path, read_ahead: 2)
      |> Enum.map(&prepare_lists/1)
      |> Enum.reduce([_first_list = [], _second_list = []], &split_list/2)
      |> Enum.map(&Enum.sort/1)

    similarity_score = calculate_similarity_score(prepared_lists)

    total_distance =
      prepared_lists
      |> Enum.zip()
      |> Enum.reduce(_total_distance = 0, &calculate_distance/2)

    %{total_distance: total_distance, similarity_score: similarity_score}
  end

  defp prepare_lists(line) do
    [lists | _line_break_character] = String.split(line, "\n")

    _result =
      lists
      |> String.split(" ")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer/1)
  end

  defp split_list([first_element, second_element], [first_list, second_list]) do
    [[first_element | first_list], [second_element | second_list]]
  end

  defp calculate_distance({first_element, second_element}, total_distance_acc) do
    distance = first_element - second_element

    total_distance_acc + abs(distance)
  end

  defp calculate_similarity_score([first_list, second_list]) do
    frequencies = Enum.frequencies(second_list)

    first_list
    |> Enum.reduce(_similarity_score_acc = 0, fn element, acc ->
      acc + element * Map.get(frequencies, element, 0)
    end)
  end
end
