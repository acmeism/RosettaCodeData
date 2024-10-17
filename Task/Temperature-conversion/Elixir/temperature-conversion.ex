defmodule Temperature do
  def conversion(t) do
    IO.puts "K : #{f(t)}"
    IO.puts "\nC : #{f(t - 273.15)}"
    IO.puts "\nF : #{f(t * 1.8 - 459.67)}"
    IO.puts "\nR : #{f(t * 1.8)}"
  end

  defp f(a) do
    Float.round(a, 2)
  end

  def task, do: conversion(21.0)
end

Temperature.task
