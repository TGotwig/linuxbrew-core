class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.38.tar.bz2"
  sha256 "d8988275aa69d7149f931c10442e9e34c0242674249e171592b430ff7b3afd02"
  license "GPL-2.0"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "e75e41ea083a1d480fd60a0a45e5ab838ad032f961ea5fb0cf8aafff070e3925" => :catalina
    sha256 "60867a965e4ea8dc1e119adfecaa2bcfe63300bb7bb3e7af635ec921bc64f599" => :mojave
    sha256 "6d00f7cb42d8e9b75d6c2ab9fa5b691b7844b14ddc268a67d60d4301f568d6f5" => :high_sierra
    sha256 "2f01f9d802f854837b43066f15e96cc55a2d94058020725dd2302dce772967f2" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
