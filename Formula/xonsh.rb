class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://github.com/xonsh/xonsh/archive/0.9.20.tar.gz"
  sha256 "f4f37e4162dc640868ad88155ad7a236079ec2a194e806415d32654bf882b99b"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6390739e04b77c641278828df323ce410905f3979d102948d48bf2080c691f83" => :catalina
    sha256 "fab51b9112369b8cade8b27ad9345c206bf79bae1f48eee41f2ee098986f1641" => :mojave
    sha256 "e5c714e48f7a27fbbc9b7a43ea5b453dfab8d20ca600fc749567deb17b11e886" => :high_sierra
    sha256 "7ed3f41e35cc78a9cf1b9976e7597d9a0f9fe2f8e7c12bb2bd04ec058303513f" => :x86_64_linux
  end

  depends_on "python@3.8"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/c4/c6/03da4efaf73f0cb5a34957fdac12046eb8d8e81618bad6f60464215b829a/prompt_toolkit-3.0.6.tar.gz"
    sha256 "7630ab85a23302839a0f26b31cc24f518e6155dea1ed395ea61b42c45941b6a6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
