class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2020.08.04/kakoune-2020.08.04.tar.bz2"
  sha256 "02469fac1ff83191165536fa52f01907db5be0a734bc90570924b3edbb9cf121"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git"

  livecheck do
    url "https://github.com/mawww/kakoune/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "6d8ec70c697c45eddc871ded6f6b3a2dd2414e71f68927ee7ecd7b3fc7b61d65" => :catalina
    sha256 "da609221aa96abae411b14308db149787c057f3500c52a84cc1e110e07628386" => :mojave
    sha256 "a7019f4cb116eeaa0a6f20f497374722947da86144bf2aa22afbadfc384a409a" => :high_sierra
    sha256 "a608370b72713803fcc7bdb9f4d165fd7513c7411b9e8eb6ade8a2d23450dbda" => :x86_64_linux
  end

  depends_on macos: :high_sierra # needs C++17
  depends_on "ncurses"

  unless OS.mac?
    fails_with gcc: "5"
    fails_with gcc: "6"
    depends_on "binutils" => :build
    depends_on "linux-headers" => :build
    depends_on "pkg-config" => :build
    depends_on "gcc@7"
  end

  uses_from_macos "libxslt" => :build

  def install
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
