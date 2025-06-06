class Dvdauthor < Formula
  desc "DVD-authoring toolset"
  homepage "https://dvdauthor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dvdauthor/dvdauthor-0.7.2.tar.gz"
  sha256 "3020a92de9f78eb36f48b6f22d5a001c47107826634a785a62dfcd080f612eb7"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/dvdauthor[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "527ecacf46ecfaa771b7d5cb556e7d0002e331a79edad4250743c096babdc2f6"
    sha256 cellar: :any,                 arm64_sonoma:   "a0b32d9b7bac066918dbbe7aa04bd718751317bc6284c3d7d87fcf77051deb46"
    sha256 cellar: :any,                 arm64_ventura:  "03d576e3150005a3c6524683afa2d234ac698fc9da7645645f43afb42ffac95a"
    sha256 cellar: :any,                 arm64_monterey: "0db62ec5affa472a427aecab0add45800f986518df8aba5026e01aff8fbee17e"
    sha256 cellar: :any,                 arm64_big_sur:  "962690a3bb6779862c3a13bda8e005928743d76106dd5b39e35b22040697b5b3"
    sha256 cellar: :any,                 sonoma:         "65714959940c5a13478460f504f45762703fd2cc8db02168cd0b32a48218882b"
    sha256 cellar: :any,                 ventura:        "c911f60dfbc5f55a1492229d1d0ba2c5d93f10724a517dceb36e49397faa604d"
    sha256 cellar: :any,                 monterey:       "7b32bfedcf0a84223d860c886930d507a26006e6f79646fe0746ec681f4228fa"
    sha256 cellar: :any,                 big_sur:        "0522363b372b042bb8a672ee3d245b8f0551f8dec40bdf791b4c6eb787e810aa"
    sha256 cellar: :any,                 catalina:       "d79a1513ecb8ba4433fd4a368aaec314416c3ca8c4ab8fcabac6ed1f523e0b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "be433be51e3fb32144acd38f8e6b623b41ae24f4fe2320eb29b8387fbb875213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7837acd0fce47d23873d6b1f1df3ba1dd75985a60e0b5c33778435eeb3094c08"
  end

  # Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
  # But we don't add either as deps because they are big.

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "libdvdread"
  depends_on "libpng"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make"
    ENV.deparallelize # Install isn't parallel-safe
    system "make", "install"
  end

  test do
    assert_match "VOBFILE", shell_output("#{bin}/dvdauthor --help 2>&1", 1)
  end
end
