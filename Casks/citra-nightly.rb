cask "citra-nightly" do
  version "1727,20211003-6183b5d"
  sha256 "618aaa82c0d0f6e5f49f157d65d87e2f9f48ebc3036616074de60c26099fe683"

  url "https://github.com/citra-emu/citra-nightly/releases/download/nightly-#{version.before_comma}/citra-osx-#{version.after_comma}.tar.gz",
      verified: "github.com/citra-emu/citra-nightly/"
  name "Citra"
  desc "Nintendo 3DS emulator"
  homepage "https://citra-emu.org/"

  livecheck do
    url :url
    strategy :github_latest do |page|
      match = page.match(%r{href=.*?/nightly[._-](\d+)/citra[._-]osx[._-](\d+[._-]\h+)\.tar\.gz}i)
      "#{match[1]},#{match[2]}"
    end
  end

  app "citra-osx-#{version.after_comma}/citra-qt.app"

  zap trash: [
    "~/Library/Preferences/com.citra-emu.citra.plist",
    "~/Library/Saved Application State/com.citra-emu.citra.savedState",
    "~/.config/citra-emu",
    "~/.local/share/citra-emu",
  ]
end
