defmodule Credo.Check.Design.TagHelper do
  alias Credo.Check.CodeHelper

  def tags(source, tag_name) do
    {:ok, regex} = Regex.compile("(\\A|[^\\?])#\s*#{tag_name}:?\s*.+", "i")

    if source =~ regex do
      source
      |> CodeHelper.clean_charlists_strings_and_sigils
      |> String.split("\n")
      |> Enum.with_index
      |> Enum.map(&find_tag(&1, regex))
      |> Enum.filter(&tags?/1)
    else
      []
    end
  end

  defp find_tag({line, index}, regex) do
    tag_list =
      regex
      |> Regex.run(line)
      |> List.wrap
      |> Enum.map(&String.trim/1)

    {index + 1, line, List.first(tag_list)}
  end

  defp tags?({_line_no, _line, nil}), do: false
  defp tags?({_line_no, _line, _tag}), do: true
end
