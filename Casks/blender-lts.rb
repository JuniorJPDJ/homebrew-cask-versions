cask "blender-lts" do
  arch = Hardware::CPU.intel? ? "x64" : "arm64"

  version "2.93.5"

  url "https://download.blender.org/release/Blender#{version.major_minor}/blender-#{version}-macos-#{arch}.dmg"
  if Hardware::CPU.intel?
    sha256 "08c929f2fcbde0233947b183e8cf53e5595b8f9eedcac749b2828a713ceb9ce0"
  else
    sha256 "4435bf05591ebeb3dcb5f9071e3fc5d10417fc04c1901e4d2073994f2cd37b06"
  end

  name "Blender"
  desc "Free and open-source 3D creation suite"
  homepage "https://www.blender.org/"

  livecheck do
    url "https://www.blender.org/download/lts/"
    regex(%r{href=.*?/blender[._-]v?(\d+(?:\.\d+)+)-macOS-#{arch}\.dmg}i)
    strategy :page_match do |page, regex|
      minor_version = page[%r{href=["'].*/download/lts/(\d+(?:[.-]\d+)+)/["' >]}i, 1]
      next [] if minor_version.blank?

      version_page = Homebrew::Livecheck::Strategy.page_content("https://www.blender.org/download/lts/#{minor_version}/")
      next [] if version_page[:content].blank?

      version_page[:content].scan(regex).flatten
    end
  end

  conflicts_with cask: "blender"

  app "Blender.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/blender.wrapper.sh"
  binary shimscript, target: "blender"

  preflight do
    # make __pycache__ directories writable, otherwise uninstall fails
    FileUtils.chmod "u+w", Dir.glob("#{staged_path}/*.app/**/__pycache__")

    File.write shimscript, <<~EOS
      #!/bin/bash
      '#{appdir}/Blender.app/Contents/MacOS/Blender' "$@"
    EOS
  end

  zap trash: [
    "~/Library/Application Support/Blender",
    "~/Library/Saved Application State/org.blenderfoundation.blender.savedState",
  ]
end
