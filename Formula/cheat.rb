class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.0.4.tar.gz"
  sha256 "4acdb68dc4ae4f0e9fd901cbcf737f571d90e3405fbf1c3a2f1a0dcab414de70"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "41c06f1b177d35c6f5869bc9b57c330721bdbc991f9ddb3f3496bca7eb091034" => :catalina
    sha256 "80520fe07b136a8afa4202ceb771c4b47fa3afa7e5b622a126a051ba2b72bc88" => :mojave
    sha256 "18a65007d5db1959a80d6a9ff9bbc31ff7c99df1c5af4b3a6420e8afd0d239b5" => :high_sierra
    sha256 "7d6675cd8c0aca29eb33577985cfbef8d0dd371a713fe62607793be0eb8e6edd" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
