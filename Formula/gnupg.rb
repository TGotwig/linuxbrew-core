class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.22.tar.bz2"
  sha256 "7c1370565e1910b9d8c4e0fb57b9de34aa062ec7bb91abad5803d791f38d855b"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "1b00809e7f0e197771c70a3d7ca6306b9ff236b2651aa1e92da1e09f6fd8c2a9" => :catalina
    sha256 "6b0855d5088f9921d2ae1a87b996214ffba8f9bf0bf467dfe2343dd390013cb5" => :mojave
    sha256 "9ef79b1ffc23456648d6714566fe5ac0cb2388b9f3dc10ee8f1811a74a475a75" => :high_sierra
    sha256 "dbaf8a4dbc4e4e6c2a41ec53f42c7a4dbb1a1fe9ea98a3bdf14ae1626c3e3625" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "adns"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"

  on_linux do
    depends_on "sqlite" => :build
    depends_on "libidn"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--enable-all-tests",
                          "--enable-symcryptrun",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
