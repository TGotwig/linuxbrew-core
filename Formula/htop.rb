class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  url "https://hisham.hm/htop/releases/2.2.0/htop-2.2.0.tar.gz"
  sha256 "d9d6826f10ce3887950d709b53ee1d8c1849a70fa38e91d5896ad8cbc6ba3c57"
  license "GPL-2.0"
  revision OS.mac? ? 1 : 2

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c06ff60960f64f5c8395f53d7419cbcce2a22ee87f0cb0138352c8a88111d21c" => :catalina
    sha256 "77aa302765353b4085dcad52356d3264183e06310dda8d5bac64642299ea2902" => :mojave
    sha256 "0ebfb655b91566ba31f8effc94d642a43305ff95bdc9b30b46fadc132e2ced0c" => :high_sierra
    sha256 "ed93b86f011de155c5d261b8c9cc9cb81fd0017667bf3ebe26ee090716bcd650" => :sierra
    sha256 "ff4f21ca883cb69101331f0071b5c6e479d16b6bd53fdc04da398a9c41497fc0" => :x86_64_linux
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses" # enables mouse scroll
  depends_on "python@3.8" => :build unless OS.mac?

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin" unless OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
