defmodule Day8 do

  def run(path) do
    path |> File.read! |> String.split("") |> part1(150)
  end

  def run2(path) do
    path |> File.read! |> String.split("") |> part2(150)
  end

  def part1(["" | layers], size), do: part1(layers, size, 1000, 0)

  def part1(all_pixels, size, _, multi_digit) when length(all_pixels) < size, do: multi_digit
  def part1(all_pixels, size, zero, multi_digit) do
    pixels = Enum.take(all_pixels, size)
    current_zero = Enum.count(pixels, fn(n) -> n == "0" end)
    case current_zero < zero do
      true ->
        part1(all_pixels -- pixels, size, current_zero, Enum.count(pixels, fn(n) -> n == "1" end) *  Enum.count(pixels, fn(n) -> n == "2" end))
      _ ->
        part1(all_pixels -- pixels, size, zero, multi_digit)
    end
  end

  def part2(["" | layers], size), do: part2(layers, List.duplicate("2", size), size)

  def part2(all_pixels, image, size) when length(all_pixels) < size, do: image
  def part2(all_pixels, image, size) do
    pixels = Enum.take(all_pixels, size)
    part2(all_pixels--pixels, Enum.map(Enum.zip(image, pixels), fn(x) -> composition(x) end), size)
  end

  def composition({"2", pixel}), do: pixel
  def composition({image_pixel, _}), do: image_pixel
end
