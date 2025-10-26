class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  # pypi sdist bug report, https://bugs.launchpad.net/brz/+bug/2111649
  url "https://github.com/breezy-team/breezy/archive/refs/tags/brz-3.3.15.tar.gz"
  sha256 "0a6353b9e42eace08abb59c2cd29e5f705d24e417abe8e2b8fc984623595b5b4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^brz[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d141e0f7da711dc02ed34af7f5a6d57535cfbf878ffb43dd3a5c71b3d9c35af1"
    sha256 cellar: :any,                 arm64_sequoia: "f2fa0a5745fd475f7fa14bb46aaefeaf11912f0193c09381f1016d731b65eb9f"
    sha256 cellar: :any,                 arm64_sonoma:  "e32406ac7594a81b0e29fa1d9210171501bce68744dd31454dd9e82f15b01324"
    sha256 cellar: :any,                 arm64_ventura: "768905b6c14d037c7c0f5f39f00b1140e7bba62a9a39a781f5a9a4ffe9784ebe"
    sha256 cellar: :any,                 sonoma:        "1b3687ada3c0af81d2c87f9d4808aed45d93e0777348db549545e2762461265f"
    sha256 cellar: :any,                 ventura:       "0a252d93a527bc5b06f37bc7c922ab4e5362aa77780d9d44961b02430d4c779c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "231e15f3d4d6a5b03c6a44e5e6856082f5e9950eb3663dc8afba7a166ebead74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b09e7fb18087a2a4659f23a2b3470dbdd83fa9d6148d6c2028016151e92589f"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/2b/f3/13a3425ddf04bd31f1caf3f4fa8de2352700c454cb0536ce3f4dbdc57a81/dulwich-0.24.1.tar.gz"
    sha256 "e19fd864f10f02bb834bb86167d92dcca1c228451b04458761fc13dabd447758"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/cd/e5/0e98b0154da2705852a1154a4d325830583670c376a6c46e9f557b0aa3c5/fastbencode-0.3.6.tar.gz"
    sha256 "114f853ebbb0a5168ac7ca4337bd9a542105e3d403b970111bfef16e0037c1c5"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/12/71/daaa7978561b9a7bfdcee4ba5ec2ead6162f6a9d2e2edf069def96085c6b/merge3-0.0.16.tar.gz"
    sha256 "0852de4381cb46be5ef4ed49e3ac20c5a4a0cd46a8ff4bbb870bc27aab543306"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/29/42/795991d063200c34094686bd3659a228caa1f4aca1afa98593d06a3d9344/patiencediff-0.2.18.tar.gz"
    sha256 "a678d8252bfb060f1f280fd32d47d917d323e93e1a94ff4ddaaba693a6f66aad"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    whoami = "Homebrew <homebrew@example.com>"
    system bin/"brz", "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system bin/"brz", "init-repo", "sample"
    system bin/"brz", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end

    # Test git compatibility
    system bin/"brz", "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end
  end
end
