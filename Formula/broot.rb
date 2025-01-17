class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v0.20.3.tar.gz"
  sha256 "2169646d9c5e8440fe778ffb6faacc40cd04643c86569e1b2f905e5241c33e1e"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "422f94ca0003fe6c2aa822159f7aeb6c6cd69b0a0d257c25da57227ccf6210f1" => :catalina
    sha256 "c2ca888fb22f6c9c91f9842537db270822bc85d251d3b2f1df2e41fda5ba49f1" => :mojave
    sha256 "012b1efd10bdd1cb3947506be3c9133d68e61fa8c4e1d351f574efdad5f9bb76" => :high_sierra
    sha256 "9aa8b4b0b256ae98c6cdd8040b58226458b5a124d709f71f76a9173f852b6bd5" => :x86_64_linux
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    return if !OS.mac? && ENV["CI"]

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
