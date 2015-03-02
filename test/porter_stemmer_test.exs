defmodule PorterStemmerTest do
  use ExUnit.Case

  test "sanity" do
    assert(true)

    file = File.open!("./test/test_data.csv", [:read])

    process_file(file)
  end

  def process_file(file) do
    row = IO.read(file, :line)

    if (row != :eof) do
      [word1, word2] = handle_row(row)
      assert(PorterStemmer.stem(word1) == word2)
      process_file(file)
    end
  end

  def handle_row(row) do
    list = Regex.split(~r/,/, String.strip(row))
  end
end
