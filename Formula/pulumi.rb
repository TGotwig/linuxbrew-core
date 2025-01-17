class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.9.1",
      revision: "c42e3ca80ae6fe385df052f6fd501ad1f0fe0ec8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cc89c2da5f592a76baba974ff903e6abbb3bad35c14c44fb354f94e6a13cdcf" => :catalina
    sha256 "ae01aaf5184cd7852cf21e695f3e03d20b2e30670045fb6af4a689bb40798dd5" => :mojave
    sha256 "de08fab01d250dc2b5bb70fe2271eb42d406860cb0e405a13d1b945bcf9efa2e" => :high_sierra
    sha256 "4f680e9f24e12c12db1e3a1d368598331c0d7b30819cb5a0db509af61975cda7" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
