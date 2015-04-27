defmodule Potion.ParserTest do
  use ESpec, async: true

  context "Addition" do
    it "shall evaluate a simple addition" do
      expect(Potion.Parser.evaluate("1 + 1")).to be 2
    end

    it "shall evaluate another simple addition" do
      expect(Potion.Parser.evaluate("1 + 3")).to be 4
    end
  end
end