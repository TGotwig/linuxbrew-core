class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/fb/89/7a26697f6fb79ced9118d3f6597925ce752ed07c056a7ecbf060c600b097/diffoscope-158.tar.gz"
  sha256 "54e6d074a783c742b18b18a63328ac6821f4bedbb3d721a5d6af6ccb5d4fe6b2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d5259deed743921cedcdd23d2b33428c62c6e93e8d43fc0e231f163c7196565f" => :catalina
    sha256 "cd8ea60817164df8a9d3bf9c0665e76e30c088e00cf21e28c567a5b067255145" => :mojave
    sha256 "8e63985868b9f4c4a905a16c113a7cffdb61fdf1e1d4f3a7dcfe2369e93d3a5e" => :high_sierra
    sha256 "0a5e6ac8cd84dc9939dcc976a31e8b68b8e97006816c4d5fcd4482bf1ba337c7" => :x86_64_linux
  end

  depends_on "gnu-tar"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.8"

  # Use resources from diffoscope[cmdline]
  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/df/a0/3544d453e6b80792452d71fdf45aac532daf1c2b2d7fc6cb712e1c3daf11/argcomplete-1.12.0.tar.gz"
    sha256 "2fbe5ed09fd2c1d727d4199feca96569a5b50d44c71b16da9c742201f7cc295c"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/63/fe/9e6c78db381934e28c7ec3d30d4f209fe24442d17f1bd8c56d13ae185cf6/libarchive-c-2.9.tar.gz"
    sha256 "9919344cec203f5db6596a29b5bc26b07ba9662925a05e24980b84709232ef60"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/e3/85/1aff76b966622868a73717abd8b501a3c91890e23a65e5f574ff6df1970f/python-magic-0.4.18.tar.gz"
    sha256 "b757db2a5289ea3f1ced9e60f072965243ea43a2221430048fd8cacab17be0ce"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/"libarchive.#{OS.mac? ? "dylib" : "so"}"
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
