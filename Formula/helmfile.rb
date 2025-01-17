class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.126.0.tar.gz"
  sha256 "27685511d0f38ab77f229783f2692ce0d1e32c355a08084f0a079c4dac64f2bc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2490a4862350d16290ab15bf952e1a50dd8bc0395be704e3284909efa910282" => :catalina
    sha256 "2eeeadca7912f5676215bd80b103f7be2334fe23e0923d9f94af2322a35bb229" => :mojave
    sha256 "1eb66c214397a9cb6aa54f40f54a4332bbc6904ee0f584491ccb8466840ea29c" => :high_sierra
    sha256 "eb7adc6803e8fb97ece83e1df9ee72b789621489ca92a572dc04065b0de23491" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      createNamespace: true                  # helm 3.2+ automatically create release namespace (default true)
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: stable/vault                    # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
