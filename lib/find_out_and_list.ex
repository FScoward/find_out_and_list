defmodule FindOutAndList do
  @moduledoc """
  Documentation for FindOutAndList.
  """

  def main(args) do
    # parse_args(args) |> process |> IO.puts
    parsed = parse_args(args)

    with {:ok, list} <- File.ls(parsed),
         result      <- file_reads(list),
    do: 
      print_list(result)
      IO.puts("finish.")
  end

  @spec parse_args([binary]) :: atom | [binary]
  def parse_args(args) do
    parse = OptionParser.parse(args,
                               switches: [ help: :boolean], # boolean型に変換する
                               aliases: [h: :help]) # :helpに変換する
    case parse do
      { [ help: true ], _, _}
        -> :help

      { [], [], _} -> :help

      { _, keyword, _}
        -> keyword
      
    end
  end

  def process(:help), do: IO.puts("please input file path")
  def process(path), do: file_list(path)

  @spec file_list([binary]) :: [binary]
  def file_list(path) do
    File.ls!(path)
  end

  def file_reads(list) do
    Enum.map(list, fn(x) -> file_read(x) end)
  end

  @spec file_read([binary]) :: map
  def file_read(path) do
    if File.dir?(path) do
    else
      read_result = File.read(path)
      map = %{:path => path, :result => read_result}
      result = case read_result do
        {:ok, content} -> %{:path => path, :content => content}
        {:error, _} -> %{:path => path, :content => "Error"}
      end
      result
    end
  end

  def print_list(list) do
    Enum.map(list, fn(x) -> try_print(x) end)
  end

  def try_print(map) do
    try do
      IO.puts(~s/******* path: #{map[:path]}, map: #{map[:content]}/)
    rescue
      _ -> IO.puts("--------------- Error")
    end
  end
end
