require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.0.16.tgz"
  sha256 "3b6eff02a32783ef6bccda828a04fa9996e8ac0164ab423260c3bc6e50abcb2f"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5c7287cff8afdf54bdf4726611f5525c67a4b763f46f9bbc2a5865be7ccdf0c" => :catalina
    sha256 "dad70dab191cbf12a6e7bfd22b6e7b835675810131b98d10397279f863ae7ff7" => :mojave
    sha256 "f4542d9fc8ccd4731ff65a71a496be739f4102578c9a13b68925bd065ef6d070" => :high_sierra
    sha256 "567695bf0bb5641e0fcc3255ebdd60f78b0cf487325ba6be51aaf275b34d9d9c" => :x86_64_linux
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
